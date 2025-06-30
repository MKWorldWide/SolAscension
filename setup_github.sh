#!/bin/bash

# Solar Ascension GitHub Setup Script
echo "🚀 Setting up GitHub repository for Solar Ascension..."

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "❌ Git repository not found. Please run 'git init' first."
    exit 1
fi

# Get repository name from user
echo "📝 Enter your GitHub username:"
read github_username

echo "📝 Enter your desired repository name (or press Enter for 'solar-ascension'):"
read repo_name

# Use default if empty
if [ -z "$repo_name" ]; then
    repo_name="solar-ascension"
fi

echo "🌐 Creating GitHub repository: $github_username/$repo_name"

# Create GitHub repository using GitHub CLI (if available)
if command -v gh &> /dev/null; then
    echo "📦 Using GitHub CLI to create repository..."
    gh repo create "$repo_name" --public --description "Solar Ascension Twitter Engine - Automated Twitter posting system for spreading the vision of America becoming the Sun Kingdom of Earth"
    
    if [ $? -eq 0 ]; then
        echo "✅ GitHub repository created successfully!"
        
        # Add remote and push
        git remote add origin "https://github.com/$github_username/$repo_name.git"
        git branch -M main
        git push -u origin main
        
        echo "🚀 Code pushed to GitHub successfully!"
        echo "🌐 Repository URL: https://github.com/$github_username/$repo_name"
    else
        echo "❌ Failed to create GitHub repository with CLI"
        echo "📝 Please create the repository manually at: https://github.com/new"
        echo "📝 Then run these commands:"
        echo "   git remote add origin https://github.com/$github_username/$repo_name.git"
        echo "   git branch -M main"
        echo "   git push -u origin main"
    fi
else
    echo "📝 GitHub CLI not found. Please create the repository manually:"
    echo "   1. Go to: https://github.com/new"
    echo "   2. Repository name: $repo_name"
    echo "   3. Description: Solar Ascension Twitter Engine - Automated Twitter posting system"
    echo "   4. Make it public"
    echo "   5. Don't initialize with README (we already have one)"
    echo ""
    echo "📝 Then run these commands:"
    echo "   git remote add origin https://github.com/$github_username/$repo_name.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
fi

echo ""
echo "🌞 Solar Ascension is ready to spread across the world!"
echo "📊 Monitor your repository at: https://github.com/$github_username/$repo_name" 