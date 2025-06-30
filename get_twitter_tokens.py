#!/usr/bin/env python3
"""
Twitter Access Token Helper
This script helps you get your Twitter access tokens for the Solar Ascension engine
"""

import tweepy
import os
from dotenv import load_dotenv

def get_access_tokens():
    """Get Twitter access tokens using OAuth 1.0a"""
    
    # Your API keys (already provided)
    api_key = "Nr8j1WFTJ2McM4SOILVYd3DhL"
    api_secret = "EkK6YFEawT50c7u5SYMZYZdK5qhSfOkiCBdi5icA2L3d7o8dMZ"
    
    print("🔐 Getting Twitter Access Tokens for Solar Ascension")
    print("=" * 50)
    
    try:
        # Create OAuth 1.0a handler
        auth = tweepy.OAuthHandler(api_key, api_secret)
        
        # Get authorization URL
        auth_url = auth.get_authorization_url()
        
        print(f"🌐 Please visit this URL to authorize the app:")
        print(f"   {auth_url}")
        print()
        print("📝 After authorizing, you'll get a PIN code.")
        print("   Enter that PIN code below:")
        
        # Get PIN from user
        pin = input("PIN Code: ").strip()
        
        # Get access tokens
        auth.get_access_token(pin)
        
        access_token = auth.access_token
        access_token_secret = auth.access_token_secret
        
        print()
        print("✅ Access tokens obtained successfully!")
        print(f"Access Token: {access_token}")
        print(f"Access Token Secret: {access_token_secret}")
        
        # Update .env file
        update_env_file(access_token, access_token_secret)
        
        return access_token, access_token_secret
        
    except Exception as e:
        print(f"❌ Error getting access tokens: {e}")
        return None, None

def update_env_file(access_token, access_token_secret):
    """Update the .env file with the new access tokens"""
    
    env_content = f"""# Twitter API Credentials
TWITTER_API_KEY=Nr8j1WFTJ2McM4SOILVYd3DhL
TWITTER_API_SECRET=EkK6YFEawT50c7u5SYMZYZdK5qhSfOkiCBdi5icA2L3d7o8dMZ
TWITTER_ACCESS_TOKEN={access_token}
TWITTER_ACCESS_TOKEN_SECRET={access_token_secret}

# AWS Credentials (for EC2 monitoring)
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_DEFAULT_REGION=us-east-1
"""
    
    with open('.env', 'w') as f:
        f.write(env_content)
    
    print("📝 .env file updated with your access tokens!")

def test_twitter_connection():
    """Test the Twitter connection"""
    
    load_dotenv()
    
    api_key = os.getenv('TWITTER_API_KEY')
    api_secret = os.getenv('TWITTER_API_SECRET')
    access_token = os.getenv('TWITTER_ACCESS_TOKEN')
    access_token_secret = os.getenv('TWITTER_ACCESS_TOKEN_SECRET')
    
    if not all([api_key, api_secret, access_token, access_token_secret]):
        print("❌ Missing Twitter credentials in .env file")
        return False
    
    try:
        auth = tweepy.OAuthHandler(api_key, api_secret)
        auth.set_access_token(access_token, access_token_secret)
        api = tweepy.API(auth)
        
        # Test connection by getting user info
        user = api.verify_credentials()
        print(f"✅ Twitter connection successful!")
        print(f"   Connected as: @{user.screen_name}")
        print(f"   User ID: {user.id}")
        
        return True
        
    except Exception as e:
        print(f"❌ Twitter connection failed: {e}")
        return False

def main():
    """Main function"""
    
    print("☀️ Solar Ascension Twitter Token Setup")
    print("=" * 40)
    
    # Check if tokens already exist
    load_dotenv()
    access_token = os.getenv('TWITTER_ACCESS_TOKEN')
    
    if access_token and access_token != 'your_access_token_here':
        print("🔍 Found existing access tokens in .env file")
        choice = input("Do you want to test the connection? (y/n): ").lower()
        
        if choice == 'y':
            if test_twitter_connection():
                print("🚀 Ready to post to Twitter!")
                return True
            else:
                print("❌ Connection failed. Getting new tokens...")
    
    # Get new tokens
    access_token, access_token_secret = get_access_tokens()
    
    if access_token and access_token_secret:
        print()
        print("🧪 Testing connection...")
        if test_twitter_connection():
            print("🎉 Setup complete! Ready to post to Twitter!")
            return True
    
    return False

if __name__ == "__main__":
    success = main()
    
    if success:
        print()
        print("🌞 Next steps:")
        print("1. Run: python3 twitter_engine_simple.py")
        print("2. The engine will post your Solar Ascension thread to Twitter!")
        print("3. Monitor logs: tail -f twitter_engine.log")
    else:
        print()
        print("❌ Setup incomplete. Please try again.") 