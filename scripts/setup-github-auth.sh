#!/bin/bash

# GitHub Authentication Setup Script for GrocerEase Chatbot
# This script helps you set up GitHub tokens and Railway deployment

set -e

echo "🔐 Setting up GitHub Authentication for GrocerEase Chatbot"
echo "=========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
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

# Check if we're in the right directory
if [ ! -f "requirements.txt" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

echo ""
print_info "This script will help you set up GitHub authentication tokens."
echo ""

# Step 1: GitHub Personal Access Token
echo "📋 Step 1: GitHub Personal Access Token"
echo "----------------------------------------"
echo "1. Go to: https://github.com/settings/tokens"
echo "2. Click 'Generate new token (classic)'"
echo "3. Set expiration to 90 days"
echo "4. Select scopes: repo, workflow"
echo "5. Copy the generated token"
echo ""

read -p "Enter your GitHub Personal Access Token: " GITHUB_TOKEN

if [ -z "$GITHUB_TOKEN" ]; then
    print_error "GitHub token is required"
    exit 1
fi

# Step 2: Railway Token
echo ""
echo "📋 Step 2: Railway Token"
echo "------------------------"
echo "1. Install Railway CLI: npm install -g @railway/cli"
echo "2. Login: railway login"
echo "3. Get your token: railway whoami"
echo ""

read -p "Enter your Railway Token: " RAILWAY_TOKEN

if [ -z "$RAILWAY_TOKEN" ]; then
    print_error "Railway token is required"
    exit 1
fi

# Step 3: Railway Service Name
echo ""
echo "📋 Step 3: Railway Service"
echo "--------------------------"
echo "1. Run: railway service list"
echo "2. Note your service name/ID"
echo ""

read -p "Enter your Railway Service Name/ID: " RAILWAY_SERVICE

if [ -z "$RAILWAY_SERVICE" ]; then
    print_error "Railway service name is required"
    exit 1
fi

# Step 4: Test tokens
echo ""
print_info "Testing tokens..."

# Test GitHub token
GITHUB_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user || echo "FAILED")
if [[ $GITHUB_RESPONSE == *"login"* ]]; then
    print_success "GitHub token is valid"
else
    print_error "GitHub token is invalid or expired"
    exit 1
fi

# Test Railway token
if command -v railway &> /dev/null; then
    RAILWAY_RESPONSE=$(railway whoami 2>&1 || echo "FAILED")
    if [[ $RAILWAY_RESPONSE != *"FAILED"* ]]; then
        print_success "Railway token is valid"
    else
        print_warning "Railway CLI not available or token invalid"
    fi
else
    print_warning "Railway CLI not installed. Install with: npm install -g @railway/cli"
fi

# Step 5: Create .env file
echo ""
print_info "Creating .env file for local development..."

cat > .env << EOF
# GitHub Authentication
GITHUB_TOKEN=$GITHUB_TOKEN

# Railway Configuration
RAILWAY_TOKEN=$RAILWAY_TOKEN
RAILWAY_SERVICE=$RAILWAY_SERVICE

# Application Configuration
MONGO_URI=your_mongodb_connection_string
GEMINI_API_KEY=your_gemini_api_key
STRUCTURED_PROMPTING_API_KEY=your_structured_prompting_api_key
EOF

print_success "Created .env file"

# Step 6: Instructions for GitHub Secrets
echo ""
echo "📋 Step 4: GitHub Repository Secrets"
echo "------------------------------------"
echo "1. Go to your repository: https://github.com/yourusername/grocer-ease-chatbot"
echo "2. Click Settings → Secrets and variables → Actions"
echo "3. Add the following secrets:"
echo ""
echo "   Name: RAILWAY_TOKEN"
echo "   Value: $RAILWAY_TOKEN"
echo ""
echo "   Name: RAILWAY_SERVICE"
echo "   Value: $RAILWAY_SERVICE"
echo ""
echo "   Name: GITHUB_TOKEN"
echo "   Value: $GITHUB_TOKEN"
echo ""

# Step 7: Branch setup
echo ""
echo "📋 Step 5: Branch Setup"
echo "----------------------"
echo "1. Create and push the prodDeploy branch:"
echo "   git checkout -b prodDeploy"
echo "   git add ."
echo "   git commit -m 'Setup production deployment'"
echo "   git push origin prodDeploy"
echo ""
echo "2. Set up branch protection:"
echo "   - Go to Settings → Branches"
echo "   - Add rule for 'prodDeploy'"
echo "   - Enable required status checks"
echo ""

# Step 8: Test deployment
echo ""
echo "📋 Step 6: Test Deployment"
echo "-------------------------"
echo "To test the deployment:"
echo "1. Make a change to your code"
echo "2. Commit and push to prodDeploy branch"
echo "3. Check GitHub Actions tab for deployment status"
echo ""

print_success "Setup completed!"
echo ""
echo "🔗 Useful Links:"
echo "- GitHub Tokens: https://github.com/settings/tokens"
echo "- Repository Settings: https://github.com/yourusername/grocer-ease-chatbot/settings"
echo "- GitHub Actions: https://github.com/yourusername/grocer-ease-chatbot/actions"
echo "- Railway Dashboard: https://railway.app/dashboard"
echo ""

print_warning "Remember to:"
echo "- Never commit the .env file to git"
echo "- Rotate tokens regularly"
echo "- Monitor deployment logs"
echo "- Set up branch protection rules" 