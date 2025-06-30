#!/bin/bash

# Solar Ascension Twitter Engine - EC2 Deployment Script
# This script sets up the Twitter engine on an EC2 instance

echo "🚀 Deploying Solar Ascension Twitter Engine to EC2..."

# Update system
echo "📦 Updating system packages..."
sudo yum update -y

# Install Python 3 and pip
echo "🐍 Installing Python 3..."
sudo yum install -y python3 python3-pip

# Install git
echo "📚 Installing git..."
sudo yum install -y git

# Create application directory
echo "📁 Creating application directory..."
mkdir -p /opt/solar-ascension
cd /opt/solar-ascension

# Copy application files (assuming they're uploaded or cloned)
echo "📋 Setting up application files..."

# Create virtual environment
echo "🔧 Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Create environment file for Twitter credentials
echo "🔐 Setting up environment variables..."
cat > .env << EOF
TWITTER_API_KEY=Nr8j1WFTJ2McM4SOILVYd3DhL
TWITTER_API_SECRET=EkK6YFEawT50c7u5SYMZYZdK5qhSfOkiCBdi5icA2L3d7o8dMZ
TWITTER_ACCESS_TOKEN=your_access_token_here
TWITTER_ACCESS_TOKEN_SECRET=your_access_token_secret_here
EOF

# Create systemd service file
echo "⚙️ Creating systemd service..."
sudo tee /etc/systemd/system/solar-ascension.service > /dev/null << EOF
[Unit]
Description=Solar Ascension Twitter Engine
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/solar-ascension
Environment=PATH=/opt/solar-ascension/venv/bin
ExecStart=/opt/solar-ascension/venv/bin/python twitter_engine.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
echo "🚀 Starting Solar Ascension Twitter Engine..."
sudo systemctl daemon-reload
sudo systemctl enable solar-ascension
sudo systemctl start solar-ascension

# Check service status
echo "📊 Checking service status..."
sudo systemctl status solar-ascension

# Create monitoring script
echo "📈 Creating monitoring script..."
cat > monitor.sh << 'EOF'
#!/bin/bash

echo "=== Solar Ascension Twitter Engine Status ==="
sudo systemctl status solar-ascension --no-pager

echo ""
echo "=== Recent Logs ==="
tail -n 20 /opt/solar-ascension/twitter_engine.log

echo ""
echo "=== System Resources ==="
free -h
df -h /
uptime
EOF

chmod +x monitor.sh

# Create backup script
echo "💾 Creating backup script..."
cat > backup.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="/opt/solar-ascension/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup logs
tar -czf $BACKUP_DIR/logs_$DATE.tar.gz *.log

# Backup configuration
cp .env $BACKUP_DIR/env_$DATE

echo "Backup completed: $BACKUP_DIR"
EOF

chmod +x backup.sh

# Set up log rotation
echo "📝 Setting up log rotation..."
sudo tee /etc/logrotate.d/solar-ascension > /dev/null << EOF
/opt/solar-ascension/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 ec2-user ec2-user
    postrotate
        systemctl reload solar-ascension
    endscript
}
EOF

echo "✅ Deployment completed!"
echo ""
echo "📋 Next steps:"
echo "1. Update .env file with your Twitter access tokens"
echo "2. Restart the service: sudo systemctl restart solar-ascension"
echo "3. Monitor logs: tail -f /opt/solar-ascension/twitter_engine.log"
echo "4. Check status: ./monitor.sh"
echo ""
echo "🌞 Solar Ascension Twitter Engine is now running on EC2!" 