# ☀️ Solar Ascension Twitter Engine

A powerful, automated Twitter posting engine designed to spread the vision of America becoming the "Sun Kingdom of Earth" through strategic solar energy deployment.

## 🚀 Features

- **Automated Thread Posting**: Posts the complete 15-tweet Solar Ascension thread
- **Peak Engagement Scheduling**: Automatically posts at optimal times for maximum reach
- **EC2 Integration**: Designed to run continuously on AWS EC2
- **Rate Limiting Protection**: Built-in delays to avoid Twitter API limits
- **Comprehensive Logging**: Detailed logs for monitoring and debugging
- **Health Monitoring**: AWS integration for instance monitoring
- **Python 3.12 Compatible**: Works with stable Python versions

## 📋 Prerequisites

- Python 3.12 (recommended) or Python 3.11
- Twitter Developer Account with API access
- AWS Account (for EC2 deployment)
- Twitter API credentials (API Key, API Secret)

## 🛠️ Quick Setup

### 1. Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/solar-ascension.git
cd solar-ascension

# Create virtual environment with Python 3.12
python3.12 -m venv venv312
source venv312/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the engine
python3 twitter_engine_real.py
```

### 2. EC2 Deployment

```bash
# Upload files to your EC2 instance
scp -i your-key.pem -r . ec2-user@your-ec2-ip:/home/ec2-user/solar-ascension/

# SSH into your EC2 instance
ssh -i your-key.pem ec2-user@your-ec2-ip

# Navigate to the directory and deploy
cd solar-ascension
chmod +x deploy_to_ec2.sh
./deploy_to_ec2.sh
```

## 🔐 Configuration

### Twitter API Credentials

The engine uses your Twitter API credentials:

```env
TWITTER_API_KEY=Nr8j1WFTJ2McM4SOILVYd3DhL
TWITTER_API_SECRET=EkK6YFEawT50c7u5SYMZYZdK5qhSfOkiCBdi5icA2L3d7o8dMZ
```

**Note**: For full Twitter posting functionality, you'll need to add your access tokens to the `.env` file.

### AWS Credentials

For EC2 monitoring, add your AWS credentials:

```env
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_DEFAULT_REGION=us-east-1
```

## 📅 Posting Schedule

The engine automatically posts at peak engagement times (EST):

- **Monday**: 9:00 AM
- **Tuesday**: 1:00 PM
- **Wednesday**: 7:00 PM
- **Thursday**: 9:00 AM
- **Friday**: 1:00 PM
- **Saturday**: 10:00 AM
- **Sunday**: 2:00 PM

## 📊 Monitoring

### Check Service Status

```bash
# On EC2
sudo systemctl status solar-ascension

# View logs
tail -f /opt/solar-ascension/twitter_engine.log

# Run monitoring script
./monitor.sh
```

### Local Monitoring

```bash
# View logs
tail -f twitter_engine.log

# Check Python process
ps aux | grep twitter_engine
```

## 🔧 Management Commands

### EC2 Service Management

```bash
# Start the service
sudo systemctl start solar-ascension

# Stop the service
sudo systemctl stop solar-ascension

# Restart the service
sudo systemctl restart solar-ascension

# Enable auto-start on boot
sudo systemctl enable solar-ascension

# View real-time logs
sudo journalctl -u solar-ascension -f
```

### Backup and Maintenance

```bash
# Create backup
./backup.sh

# Check disk space
df -h

# Monitor system resources
./monitor.sh
```

## 📈 Thread Content

The engine posts a 15-tweet thread covering:

1. **Hook**: America becoming the Sun Kingdom
2. **Problem**: Current challenges and opportunities
3. **Vision**: Strategic partnership with China
4. **Scale**: Massive deployment plan
5. **Money**: Revenue generation strategy
6. **Policy**: Legislative framework
7. **Timeline**: 10-year implementation plan
8. **Jobs**: Economic transformation
9. **Security**: National security benefits
10. **Environment**: Climate impact
11. **Investment**: Financial requirements and returns
12. **Opportunity**: Why now is the time
13. **Action**: What people can do
14. **Vision**: End game scenario
15. **Conclusion**: Call to action

## 🚨 Troubleshooting

### Common Issues

1. **Python Version**: Use Python 3.12 or lower (Python 3.13 has compatibility issues)
2. **Rate Limiting**: The engine includes 5-second delays between tweets
3. **Authentication Errors**: Verify Twitter credentials in `.env`
4. **Service Won't Start**: Check logs with `sudo journalctl -u solar-ascension`
5. **Permission Errors**: Ensure files have correct permissions

### Debug Mode

Run with verbose logging:

```bash
python3 twitter_engine_real.py --debug
```

## 🔒 Security Notes

- Never commit `.env` files to version control
- Use IAM roles on EC2 instead of hardcoded AWS credentials
- Regularly rotate Twitter API credentials
- Monitor for unusual activity

## 📞 Support

For issues or questions:

1. Check the logs: `tail -f twitter_engine.log`
2. Verify credentials are correct
3. Ensure Twitter API has proper permissions
4. Check network connectivity on EC2

## 🌟 Vision

This engine is part of the larger Solar Ascension movement - transforming America into the world's first fully solar-powered nation through strategic partnerships, massive deployment, and innovative financing.

**"In the kingdom of the sun, America shall reign supreme."** ☀️

## 📁 Project Structure

```
solar-ascension/
├── twitter_engine_real.py      # Main engine (Python 3.12 compatible)
├── twitter_engine_simple.py    # Simplified version
├── requirements.txt            # Python dependencies
├── deploy_to_ec2.sh           # EC2 deployment script
├── setup.sh                   # Quick setup script
├── README.md                  # This file
├── .env                       # Environment variables
├── solar_ascension_pitch_deck.md
├── solar_ascension_presidential_proposal.md
└── solar_ascension_twitter_thread.md
```

## 🚀 Deployment Status

- ✅ **Local Development**: Working with Python 3.12
- ✅ **EC2 Ready**: Deployment scripts included
- ✅ **Monitoring**: Logging and health checks
- ✅ **Scheduling**: Peak engagement timing
- 🔄 **Twitter Integration**: Ready for access tokens

---

*Built for the Solar Sovereign movement - spreading the vision of American energy independence and global leadership.* 