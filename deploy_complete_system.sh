#!/bin/bash

# Solar Ascension Complete System Deployment Script
# Deploys AI engine, multi-platform posting, analytics dashboard, and policy advocacy

set -e

echo "☀️ Solar Ascension Complete System Deployment"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Check Python version
print_status "Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
required_version="3.11"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" = "$required_version" ]; then
    print_success "Python $python_version is compatible"
else
    print_error "Python $python_version is not compatible. Required: $required_version or higher"
    exit 1
fi

# Create project directory
PROJECT_DIR="/opt/solar-ascension"
print_status "Setting up project directory: $PROJECT_DIR"

sudo mkdir -p $PROJECT_DIR
sudo chown $USER:$USER $PROJECT_DIR
cd $PROJECT_DIR

# Copy project files
print_status "Copying project files..."
cp -r . $PROJECT_DIR/ 2>/dev/null || print_warning "No local files to copy (running from deployment)"

# Create virtual environment
print_status "Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Upgrade pip
print_status "Upgrading pip..."
pip install --upgrade pip

# Install dependencies
print_status "Installing Python dependencies..."
pip install -r requirements.txt

# Create systemd service file
print_status "Creating systemd service..."
sudo tee /etc/systemd/system/solar-ascension.service > /dev/null <<EOF
[Unit]
Description=Solar Ascension Master Controller
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$PROJECT_DIR
Environment=PATH=$PROJECT_DIR/venv/bin
ExecStart=$PROJECT_DIR/venv/bin/python solar_ascension_master.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Create environment file
print_status "Creating environment configuration..."
cat > $PROJECT_DIR/.env <<EOF
# Solar Ascension Environment Configuration
TWITTER_API_KEY=Nr8j1WFTJ2McM4SOILVYd3DhL
TWITTER_API_SECRET=EkK6YFEawT50c7u5SYMZYZdK5qhSfOkiCBdi5icA2L3d7o8dMZ
OPENAI_API_KEY=your_openai_api_key_here

# Optional API Keys for Enhanced Features
NREL_API_KEY=your_nrel_api_key_here
EIA_API_KEY=your_eia_api_key_here
WEATHER_API_KEY=your_weather_api_key_here

# Dashboard Configuration
DASHBOARD_PORT=8050
DASHBOARD_HOST=0.0.0.0

# Logging Configuration
LOG_LEVEL=INFO
LOG_FILE=$PROJECT_DIR/solar_ascension.log
EOF

# Create log directory
print_status "Setting up logging..."
mkdir -p $PROJECT_DIR/logs
touch $PROJECT_DIR/solar_ascension.log

# Create backup script
print_status "Creating backup script..."
cat > $PROJECT_DIR/backup.sh <<'EOF'
#!/bin/bash
# Solar Ascension Backup Script

BACKUP_DIR="/opt/solar-ascension/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="solar_ascension_backup_$DATE.tar.gz"

mkdir -p $BACKUP_DIR

echo "Creating backup: $BACKUP_FILE"

tar -czf $BACKUP_DIR/$BACKUP_FILE \
    --exclude='venv' \
    --exclude='*.log' \
    --exclude='backups' \
    --exclude='__pycache__' \
    /opt/solar-ascension

echo "Backup completed: $BACKUP_DIR/$BACKUP_FILE"

# Keep only last 10 backups
cd $BACKUP_DIR
ls -t | tail -n +11 | xargs -r rm

echo "Old backups cleaned up"
EOF

chmod +x $PROJECT_DIR/backup.sh

# Create monitoring script
print_status "Creating monitoring script..."
cat > $PROJECT_DIR/monitor.sh <<'EOF'
#!/bin/bash
# Solar Ascension Monitoring Script

echo "=== Solar Ascension System Status ==="
echo

# Check service status
echo "Service Status:"
systemctl is-active solar-ascension
echo

# Check logs
echo "Recent Logs (last 10 lines):"
journalctl -u solar-ascension -n 10 --no-pager
echo

# Check disk space
echo "Disk Usage:"
df -h /opt/solar-ascension
echo

# Check memory usage
echo "Memory Usage:"
free -h
echo

# Check if dashboard is running
echo "Dashboard Status:"
curl -s http://localhost:8050 > /dev/null && echo "Dashboard: Running" || echo "Dashboard: Not responding"
echo

# Check Python processes
echo "Python Processes:"
ps aux | grep python | grep solar
echo
EOF

chmod +x $PROJECT_DIR/monitor.sh

# Create update script
print_status "Creating update script..."
cat > $PROJECT_DIR/update.sh <<'EOF'
#!/bin/bash
# Solar Ascension Update Script

echo "Updating Solar Ascension system..."

# Stop service
sudo systemctl stop solar-ascension

# Backup current installation
./backup.sh

# Update dependencies
source venv/bin/activate
pip install --upgrade -r requirements.txt

# Restart service
sudo systemctl start solar-ascension

echo "Update completed successfully"
EOF

chmod +x $PROJECT_DIR/update.sh

# Create health check script
print_status "Creating health check script..."
cat > $PROJECT_DIR/health_check.sh <<'EOF'
#!/bin/bash
# Solar Ascension Health Check Script

PROJECT_DIR="/opt/solar-ascension"
LOG_FILE="$PROJECT_DIR/solar_ascension.log"

# Check if service is running
if ! systemctl is-active --quiet solar-ascension; then
    echo "ERROR: Solar Ascension service is not running"
    exit 1
fi

# Check if log file exists and has recent activity
if [ ! -f "$LOG_FILE" ]; then
    echo "ERROR: Log file not found"
    exit 1
fi

# Check if log file has been updated in last 5 minutes
if [ $(find "$LOG_FILE" -mmin -5 | wc -l) -eq 0 ]; then
    echo "WARNING: Log file has not been updated recently"
fi

# Check disk space
DISK_USAGE=$(df /opt/solar-ascension | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 90 ]; then
    echo "WARNING: Disk usage is high: ${DISK_USAGE}%"
fi

# Check memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
if [ $MEMORY_USAGE -gt 90 ]; then
    echo "WARNING: Memory usage is high: ${MEMORY_USAGE}%"
fi

echo "Health check passed"
exit 0
EOF

chmod +x $PROJECT_DIR/health_check.sh

# Reload systemd and enable service
print_status "Enabling systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable solar-ascension

# Create cron job for health checks
print_status "Setting up automated health checks..."
(crontab -l 2>/dev/null; echo "*/5 * * * * $PROJECT_DIR/health_check.sh >> $PROJECT_DIR/health_check.log 2>&1") | crontab -

# Set proper permissions
print_status "Setting file permissions..."
chmod +x $PROJECT_DIR/*.py
chmod +x $PROJECT_DIR/*.sh
chmod 600 $PROJECT_DIR/.env

# Create README for the deployed system
print_status "Creating deployment documentation..."
cat > $PROJECT_DIR/DEPLOYMENT_README.md <<EOF
# Solar Ascension Complete System Deployment

## System Components

1. **AI Engine** (`ai_engine.py`) - Core AI-powered content generation
2. **Multi-Platform Engine** (`multi_platform_engine.py`) - Social media automation
3. **Analytics Dashboard** (`analytics_dashboard.py`) - Real-time monitoring
4. **Policy Advocacy** (`policy_advocacy.py`) - Legislative tracking and advocacy
5. **Master Controller** (`solar_ascension_master.py`) - System orchestration

## Service Management

### Start the system:
\`\`\`bash
sudo systemctl start solar-ascension
\`\`\`

### Stop the system:
\`\`\`bash
sudo systemctl stop solar-ascension
\`\`\`

### Check status:
\`\`\`bash
sudo systemctl status solar-ascension
\`\`\`

### View logs:
\`\`\`bash
sudo journalctl -u solar-ascension -f
\`\`\`

## Monitoring and Maintenance

### Run health check:
\`\`\`bash
./health_check.sh
\`\`\`

### View system status:
\`\`\`bash
./monitor.sh
\`\`\`

### Create backup:
\`\`\`bash
./backup.sh
\`\`\`

### Update system:
\`\`\`bash
./update.sh
\`\`\`

## Dashboard Access

The analytics dashboard is available at:
- Local: http://localhost:8050
- Network: http://[server-ip]:8050

## Configuration

Edit the environment file to configure API keys and settings:
\`\`\`bash
nano .env
\`\`\`

## Logs

- System logs: \`journalctl -u solar-ascension\`
- Application logs: \`solar_ascension.log\`
- Health check logs: \`health_check.log\`

## Troubleshooting

1. Check service status: \`sudo systemctl status solar-ascension\`
2. View recent logs: \`sudo journalctl -u solar-ascension -n 50\`
3. Run health check: \`./health_check.sh\`
4. Restart service: \`sudo systemctl restart solar-ascension\`

## Backup and Recovery

Backups are stored in \`/opt/solar-ascension/backups/\`
To restore from backup:
\`\`\`bash
tar -xzf backups/solar_ascension_backup_[DATE].tar.gz -C /
\`\`\`
EOF

# Final setup
print_status "Finalizing deployment..."

# Create symbolic link for easy access
sudo ln -sf $PROJECT_DIR /usr/local/bin/solar-ascension

# Start the service
print_status "Starting Solar Ascension system..."
sudo systemctl start solar-ascension

# Wait a moment for service to start
sleep 5

# Check if service started successfully
if systemctl is-active --quiet solar-ascension; then
    print_success "Solar Ascension system started successfully!"
else
    print_error "Failed to start Solar Ascension system"
    sudo systemctl status solar-ascension
    exit 1
fi

# Display final information
echo
print_success "Solar Ascension Complete System Deployment Successful!"
echo
echo "System Information:"
echo "==================="
echo "Installation Directory: $PROJECT_DIR"
echo "Service Name: solar-ascension"
echo "Dashboard URL: http://localhost:8050"
echo "Log File: $PROJECT_DIR/solar_ascension.log"
echo
echo "Management Commands:"
echo "==================="
echo "Start:     sudo systemctl start solar-ascension"
echo "Stop:      sudo systemctl stop solar-ascension"
echo "Status:    sudo systemctl status solar-ascension"
echo "Logs:      sudo journalctl -u solar-ascension -f"
echo "Monitor:   $PROJECT_DIR/monitor.sh"
echo "Backup:    $PROJECT_DIR/backup.sh"
echo "Update:    $PROJECT_DIR/update.sh"
echo
echo "Next Steps:"
echo "==========="
echo "1. Configure API keys in $PROJECT_DIR/.env"
echo "2. Access dashboard at http://localhost:8050"
echo "3. Monitor system with ./monitor.sh"
echo "4. Set up regular backups with ./backup.sh"
echo
print_success "Deployment completed! The Sun Kingdom awaits! ☀️" 