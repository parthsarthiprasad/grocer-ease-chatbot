# GitHub Authentication Setup Guide

This guide helps you set up GitHub authentication tokens for managing access to your GrocerEase Chatbot repository and deployment.

## 1. Personal Access Token (PAT) Setup

### Step 1: Generate a Personal Access Token

1. **Go to GitHub Settings**
   - Visit: https://github.com/settings/tokens
   - Or navigate: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)

2. **Generate New Token**
   - Click "Generate new token (classic)"
   - Give it a descriptive name: `GrocerEase-Chatbot-Deployment`

3. **Set Token Expiration**
   - Choose expiration: 90 days (recommended for security)
   - Or set to "No expiration" if needed

4. **Select Scopes (Permissions)**
   - **repo** (Full control of private repositories)
     - `repo:status`
     - `repo_deployment`
     - `public_repo`
   - **workflow** (Update GitHub Action workflows)
   - **admin:org** (if deploying for an organization)

5. **Generate Token**
   - Click "Generate token"
   - **IMPORTANT**: Copy the token immediately - you won't see it again!

### Step 2: Store Token Securely

```bash
# Store token in environment variable (temporary)
export GITHUB_TOKEN="ghp_your_token_here"

# Or add to your shell profile (~/.bashrc, ~/.zshrc)
echo 'export GITHUB_TOKEN="ghp_your_token_here"' >> ~/.bashrc
source ~/.bashrc
```

## 2. Repository Secrets Setup

### Step 1: Add Repository Secrets

1. **Go to Repository Settings**
   - Navigate to your repository: https://github.com/yourusername/grocer-ease-chatbot
   - Click "Settings" tab

2. **Access Secrets**
   - Click "Secrets and variables" → "Actions"

3. **Add Required Secrets**

   **For Railway Deployment:**
   ```
   Name: RAILWAY_TOKEN
   Value: [Your Railway API Token]
   ```

   ```
   Name: RAILWAY_SERVICE
   Value: [Your Railway Service Name/ID]
   ```

   **For GitHub Actions:**
   ```
   Name: GITHUB_TOKEN
   Value: [Your Personal Access Token]
   ```

### Step 2: Railway Token Setup

1. **Get Railway Token**
   ```bash
   # Install Railway CLI
   npm install -g @railway/cli
   
   # Login to Railway
   railway login
   
   # Get your token
   railway whoami
   ```

2. **Get Service ID**
   ```bash
   # List your services
   railway service list
   
   # Or get service details
   railway service show
   ```

## 3. Branch Protection Setup

### Step 1: Protect Main Branch

1. **Go to Branch Settings**
   - Repository → Settings → Branches

2. **Add Branch Protection Rule**
   - Click "Add rule"
   - Branch name pattern: `main`
   - Enable:
     - ✅ Require a pull request before merging
     - ✅ Require status checks to pass before merging
     - ✅ Require branches to be up to date before merging
     - ✅ Include administrators

### Step 2: Protect Production Branch

1. **Add Protection for prodDeploy**
   - Branch name pattern: `prodDeploy`
   - Enable:
     - ✅ Require a pull request before merging
     - ✅ Require status checks to pass before merging
     - ✅ Restrict pushes that create files
     - ✅ Allow force pushes (if needed for deployment)

## 4. GitHub Actions Workflow Permissions

### Update Workflow Permissions

Edit `.github/workflows/prod-deploy.yml`:

```yaml
name: Deploy to Railway Production

on:
  push:
    branches:
      - prodDeploy

permissions:
  contents: read
  deployments: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Railway CLI
        run: npm install -g @railway/cli

      - name: Deploy to Railway
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
        run: |
          railway up --service ${{ secrets.RAILWAY_SERVICE }}
```

## 5. Environment Variables Setup

### Local Development

Create `.env` file (not committed to git):

```env
# GitHub
GITHUB_TOKEN=ghp_your_token_here

# Railway
RAILWAY_TOKEN=your_railway_token_here
RAILWAY_SERVICE=your_service_name

# Application
MONGO_URI=your_mongodb_connection_string
GEMINI_API_KEY=your_gemini_api_key
STRUCTURED_PROMPTING_API_KEY=your_structured_prompting_api_key
```

### Production Environment

Set these in Railway dashboard:
1. Go to your Railway project
2. Click on your service
3. Go to "Variables" tab
4. Add all required environment variables

## 6. Testing Authentication

### Test GitHub Token

```bash
# Test GitHub API access
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/user

# Test repository access
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/yourusername/grocer-ease-chatbot
```

### Test Railway Token

```bash
# Test Railway CLI
railway whoami

# Test service access
railway service list
```

## 7. Security Best Practices

### Token Security
- ✅ Use least privilege principle
- ✅ Set appropriate expiration dates
- ✅ Rotate tokens regularly
- ✅ Never commit tokens to code
- ✅ Use environment variables
- ✅ Monitor token usage

### Repository Security
- ✅ Enable branch protection
- ✅ Require code reviews
- ✅ Enable security scanning
- ✅ Regular dependency updates
- ✅ Monitor for vulnerabilities

## 8. Troubleshooting

### Common Issues

1. **Token Expired**
   ```bash
   # Generate new token and update secrets
   # Update environment variables
   ```

2. **Permission Denied**
   ```bash
   # Check token scopes
   # Verify repository access
   # Check branch protection rules
   ```

3. **Workflow Fails**
   ```bash
   # Check GitHub Actions logs
   # Verify secrets are set correctly
   # Check Railway service status
   ```

### Debug Commands

```bash
# Check GitHub token validity
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/user

# Check Railway connection
railway status

# Check workflow permissions
gh auth status
```

## 9. Next Steps

1. **Set up monitoring**
   - GitHub repository insights
   - Railway deployment monitoring
   - Application health checks

2. **Configure alerts**
   - Deployment notifications
   - Error monitoring
   - Performance alerts

3. **Documentation**
   - Update README with deployment info
   - Document environment setup
   - Create troubleshooting guide

## Support

If you encounter issues:
1. Check GitHub Actions logs
2. Verify token permissions
3. Test authentication manually
4. Review security settings
5. Contact support if needed 