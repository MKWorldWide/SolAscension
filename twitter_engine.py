#!/usr/bin/env python3
"""
Solar Ascension Twitter Engine
A lightweight Twitter posting engine for viral outreach
"""

import tweepy
import time
import json
import schedule
import logging
import requests
from datetime import datetime, timedelta
import boto3
import os
from typing import List, Dict

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('twitter_engine.log'),
        logging.StreamHandler()
    ]
)

class SolarAscensionTwitterEngine:
    def __init__(self, twitter_api_key: str, twitter_api_secret: str, 
                 twitter_access_token: str, twitter_access_token_secret: str):
        """Initialize Twitter API client"""
        self.auth = tweepy.OAuthHandler(twitter_api_key, twitter_api_secret)
        self.auth.set_access_token(twitter_access_token, twitter_access_token_secret)
        self.api = tweepy.API(self.auth, wait_on_rate_limit=True)
        self.client = tweepy.Client(
            consumer_key=twitter_api_key,
            consumer_secret=twitter_api_secret,
            access_token=twitter_access_token,
            access_token_secret=twitter_access_token_secret
        )
        
        # Thread tweets for Solar Ascension
        self.solar_thread = [
            {
                "text": "☀️ AMERICA IS ABOUT TO BECOME THE SUN KINGDOM OF EARTH 🌟\n\nWe're not just going solar—we're going to OWN the sun.\n\nA thread on how America will become the world's first fully solar-powered nation and use it to:\n• Pay off our $34T debt\n• Fund universal healthcare\n• Lead the global energy revolution\n\n🧵👇",
                "hashtags": "#SolarAscension #EnergyIndependence"
            },
            {
                "text": "🔥 THE REALITY CHECK:\n\n• We're $34 TRILLION in debt\n• Dependent on foreign energy\n• China leads solar manufacturing\n• Climate crisis accelerating\n\nBut here's the thing: China has what we need, and we have what they want.\n\nIt's time for a BOLD partnership, not petty competition.",
                "hashtags": "#SolarAscension #AmericanSolar"
            },
            {
                "text": "⚡️ PROJECT SOLAR ASCENSION: PHASE I\n\nWe partner with China (yes, China) because:\n• They make 80% of global solar panels\n• They have the battery technology\n• They have the manufacturing scale\n\nWe create a \"Solar Bridge Accord\" - fair tech transfer, joint development, mutual prosperity.\n\nBold? Yes. Necessary? Absolutely.",
                "hashtags": "#SolarAscension #Innovation"
            },
            {
                "text": "🏗️ PHASE II: THE DEPLOYMENT\n\n• 10 MILLION acres of federal land → solar farms\n• 500+ GIGAWATTS of solar generation\n• Every new building → solar + battery mandatory\n• Every highway → solar panels + EV chargers\n• 100% subsidized home solar retrofits\n\nThis isn't incremental change.\nThis is REVOLUTION.",
                "hashtags": "#SolarAscension #ClimateAction"
            },
            {
                "text": "💰 PHASE III: PROFIT FROM THE SUN\n\nWe don't just go solar—we go SOLAR RICH:\n\n• Sell excess energy to Canada, Mexico, Caribbean\n• $200+ BILLION annually in energy exports\n• National Solar Bonds backed by solar revenue\n• Every GW sold = debt reduction\n\nThe sun doesn't send us a bill.\nIt sends us PROFITS.",
                "hashtags": "#SolarAscension #EnergyIndependence"
            },
            {
                "text": "📜 THE POLICY FRAMEWORK:\n\n• 10-year solar tax holiday\n• Reverse harmful 2025 tax bill clauses\n• Exempt clean tech from foreign component penalties\n• Streamlined approvals for solar projects\n\nGovernment should ENABLE, not obstruct.\nThe sun is ready. Are we?",
                "hashtags": "#SolarAscension #Policy"
            },
            {
                "text": "⏰ THE 10-YEAR PLAN:\n\nYears 1-2: Foundation\n• Chinese partnerships\n• Policy framework\n• Pilot projects\n\nYears 3-5: Scale-Up\n• Federal land deployment\n• Urban mandates\n• Export infrastructure\n\nYears 6-10: DOMINATION\n• 100% solar independence\n• Global energy leadership\n• Debt elimination",
                "hashtags": "#SolarAscension #Future"
            },
            {
                "text": "👷 THE JOB CREATION:\n\n• 5+ MILLION new solar jobs\n• High-paying manufacturing positions\n• Installation and maintenance careers\n• Research and development roles\n\nThis isn't just energy—it's ECONOMIC TRANSFORMATION.\n\nEvery solar panel = American jobs\nEvery battery = American prosperity",
                "hashtags": "#SolarAscension #Jobs"
            },
            {
                "text": "🛡️ NATIONAL SECURITY BENEFITS:\n\n• 100% energy independence\n• No more foreign oil dependence\n• Solar-powered military installations\n• Grid resilience and redundancy\n\nEnergy security = National security\nSolar power = American power",
                "hashtags": "#SolarAscension #Security"
            },
            {
                "text": "🌍 ENVIRONMENTAL IMPACT:\n\n• 100% renewable energy\n• Zero carbon emissions\n• Clean air and water\n• Biodiversity protection\n\nWe save the planet WHILE making money.\nThat's not a trade-off—that's WINNING.",
                "hashtags": "#SolarAscension #ClimateAction"
            },
            {
                "text": "💡 THE NUMBERS:\n\nInvestment Required:\n• Phase I: $50B\n• Phase II: $500B\n• Phase III: $200B\n\nAnnual Returns:\n• $300+ billion in revenue\n• $2+ trillion debt reduction over 10 years\n• 5+ million jobs created\n\nThis isn't spending—it's INVESTING in America's future.",
                "hashtags": "#SolarAscension #Investment"
            },
            {
                "text": "🚀 WHY NOW:\n\n• Technology is ready\n• China is willing to partner\n• Climate crisis demands action\n• Economic opportunity is massive\n• Political will is building\n\nThe stars (and sun) are aligned.\nThe question is: Do we have the courage to act?",
                "hashtags": "#SolarAscension #Now"
            },
            {
                "text": "📢 WHAT YOU CAN DO:\n\n• Share this thread\n• Contact your representatives\n• Support solar initiatives\n• Invest in solar companies\n• Join the solar movement\n\nThis isn't just policy—it's a MOVEMENT.\nAmerica's solar future starts with YOU.",
                "hashtags": "#SolarAscension #Action"
            },
            {
                "text": "🌟 THE END GAME:\n\nAmerica becomes the \"Sun Kingdom of Earth\"\n• Global energy leader\n• Economic superpower\n• Environmental steward\n• Technological innovator\n\nWe don't just catch up—we LEAP AHEAD.\nWe don't just compete—we DOMINATE.",
                "hashtags": "#SolarAscension #Vision"
            },
            {
                "text": "☀️ FINAL THOUGHT:\n\nThe sun rises every day.\nIt's free. It's unlimited. It's American.\n\nThe question isn't whether we can do this.\nThe question is whether we have the VISION to see it.\n\nAmerica's solar ascension begins NOW.\n\nRT if you're ready for the Sun Kingdom! 🌟",
                "hashtags": "#SolarAscension #EnergyIndependence #AmericanSolar #ClimateAction #Innovation"
            }
        ]
        
        self.thread_id = None
        self.posted_tweets = []
        
    def post_tweet(self, text: str, reply_to: str = None) -> str:
        """Post a single tweet and return the tweet ID"""
        try:
            if reply_to:
                response = self.client.create_tweet(text=text, in_reply_to_tweet_id=reply_to)
            else:
                response = self.client.create_tweet(text=text)
            
            tweet_id = response.data['id']
            logging.info(f"Posted tweet: {tweet_id}")
            return tweet_id
            
        except Exception as e:
            logging.error(f"Error posting tweet: {e}")
            return None
    
    def post_thread(self) -> bool:
        """Post the complete Solar Ascension thread"""
        try:
            logging.info("Starting Solar Ascension thread posting...")
            
            # Post first tweet
            first_tweet_id = self.post_tweet(self.solar_thread[0]["text"])
            if not first_tweet_id:
                return False
                
            self.thread_id = first_tweet_id
            self.posted_tweets = [first_tweet_id]
            
            # Post remaining tweets as replies
            for i, tweet_data in enumerate(self.solar_thread[1:], 1):
                # Add hashtags to the tweet
                full_text = f"{tweet_data['text']}\n\n{tweet_data['hashtags']}"
                
                # Post as reply to previous tweet
                tweet_id = self.post_tweet(full_text, reply_to=self.posted_tweets[-1])
                if tweet_id:
                    self.posted_tweets.append(tweet_id)
                
                # Wait between tweets to avoid rate limiting
                time.sleep(30)
            
            logging.info(f"Thread posted successfully! Thread ID: {self.thread_id}")
            return True
            
        except Exception as e:
            logging.error(f"Error posting thread: {e}")
            return False
    
    def post_single_tweet(self, tweet_index: int) -> bool:
        """Post a single tweet from the thread"""
        if 0 <= tweet_index < len(self.solar_thread):
            tweet_data = self.solar_thread[tweet_index]
            full_text = f"{tweet_data['text']}\n\n{tweet_data['hashtags']}"
            return self.post_tweet(full_text) is not None
        return False
    
    def get_engagement_stats(self) -> Dict:
        """Get engagement statistics for posted tweets"""
        stats = {
            "total_tweets": len(self.posted_tweets),
            "thread_id": self.thread_id,
            "tweet_ids": self.posted_tweets
        }
        return stats

def load_aws_credentials(credentials_path: str) -> Dict:
    """Load AWS credentials from CSV file"""
    try:
        import pandas as pd
        df = pd.read_csv(credentials_path)
        credentials = {
            'aws_access_key_id': df.iloc[0]['Access key ID'],
            'aws_secret_access_key': df.iloc[0]['Secret access key'],
            'region': 'us-east-1'  # Default region
        }
        return credentials
    except Exception as e:
        logging.error(f"Error loading AWS credentials: {e}")
        return None

def setup_ec2_monitoring(aws_credentials: Dict):
    """Setup EC2 monitoring and health checks"""
    try:
        ec2 = boto3.client('ec2', **aws_credentials)
        # Get instance metadata
        response = requests.get('http://169.254.169.254/latest/meta-data/instance-id')
        instance_id = response.text
        
        logging.info(f"EC2 Instance ID: {instance_id}")
        return ec2, instance_id
    except Exception as e:
        logging.error(f"Error setting up EC2 monitoring: {e}")
        return None, None

def main():
    """Main execution function"""
    # Load credentials
    credentials_path = '/Users/sovereign/Library/CloudStorage/OneDrive-Personal/Documents/MK World Wide/Primal Genesis/Cursor/PGES_DeveloperUser_accessKeys.csv'
    
    # Twitter API credentials (from environment variables for security)
    twitter_credentials = {
        'api_key': os.getenv('TWITTER_API_KEY', 'Nr8j1WFTJ2McM4SOILVYd3DhL'),
        'api_secret': os.getenv('TWITTER_API_SECRET', 'EkK6YFEawT50c7u5SYMZYZdK5qhSfOkiCBdi5icA2L3d7o8dMZ'),
        'access_token': os.getenv('TWITTER_ACCESS_TOKEN'),
        'access_token_secret': os.getenv('TWITTER_ACCESS_TOKEN_SECRET')
    }
    
    # Initialize Twitter engine
    engine = SolarAscensionTwitterEngine(
        twitter_credentials['api_key'],
        twitter_credentials['api_secret'],
        twitter_credentials['access_token'],
        twitter_credentials['access_token_secret']
    )
    
    # Load AWS credentials
    aws_creds = load_aws_credentials(credentials_path)
    if aws_creds:
        ec2_client, instance_id = setup_ec2_monitoring(aws_creds)
    
    # Schedule posting times (peak engagement hours)
    def post_solar_thread():
        """Scheduled function to post the Solar Ascension thread"""
        logging.info("Executing scheduled Solar Ascension thread posting...")
        success = engine.post_thread()
        if success:
            stats = engine.get_engagement_stats()
            logging.info(f"Thread posted successfully! Stats: {stats}")
        else:
            logging.error("Failed to post thread")
    
    # Schedule posts for peak engagement times (EST)
    schedule.every().monday.at("09:00").do(post_solar_thread)
    schedule.every().tuesday.at("13:00").do(post_solar_thread)
    schedule.every().wednesday.at("19:00").do(post_solar_thread)
    schedule.every().thursday.at("09:00").do(post_solar_thread)
    schedule.every().friday.at("13:00").do(post_solar_thread)
    schedule.every().saturday.at("10:00").do(post_solar_thread)
    schedule.every().sunday.at("14:00").do(post_solar_thread)
    
    # Post immediately for testing
    logging.info("Posting initial Solar Ascension thread...")
    post_solar_thread()
    
    # Keep the script running
    logging.info("Twitter engine started. Monitoring for scheduled posts...")
    while True:
        schedule.run_pending()
        time.sleep(60)  # Check every minute

if __name__ == "__main__":
    main() 