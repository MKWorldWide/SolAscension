#!/bin/bash

# Solar Ascension Twitter Engine - Quick Setup
echo "☀️ Setting up Solar Ascension Twitter Engine..."

# Check if running on EC2
if curl -s http://169.254.169.254/latest/meta-data/instance-id > /dev/null 2>&1; then
    echo "🌐 Detected EC2 environment"
    IS_EC2=true
else
    echo "💻 Running locally"
    IS_EC2=false
fi

# Install Python dependencies
echo "📦 Installing dependencies..."
pip3 install -r requirements.txt

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "🔐 Creating .env file..."
    cat > .env << EOF
# Twitter API Credentials
TWITTER_API_KEY=Nr8j1WFTJ2McM4SOILVYd3DhL
TWITTER_API_SECRET=EkK6YFEawT50c7u5SYMZYZdK5qhSfOkiCBdi5icA2L3d7o8dMZ
TWITTER_ACCESS_TOKEN=your_access_token_here
TWITTER_ACCESS_TOKEN_SECRET=your_access_token_secret_here

# AWS Credentials (for EC2 monitoring)
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_DEFAULT_REGION=us-east-1
EOF
    echo "⚠️  Please update .env file with your Twitter access tokens!"
fi

# Make scripts executable
chmod +x twitter_engine.py
chmod +x deploy_to_ec2.sh

echo "✅ Setup completed!"
echo ""
echo "📋 To get started:"
echo "1. Update .env with your Twitter access tokens"
echo "2. Run: python3 twitter_engine.py"
echo ""
echo "🚀 For EC2 deployment:"
echo "1. Upload files to EC2"
echo "2. Run: ./deploy_to_ec2.sh"
echo ""
echo "🌞 Ready to spread the Solar Ascension message!" 