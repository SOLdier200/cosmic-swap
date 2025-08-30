#!/bin/bash

echo "🌌 COSMIC SOLANA SWAP - GitHub & Vercel Deployment"
echo "=================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -f "server.js" ]; then
    echo "❌ Error: Run this script from the project root directory"
    exit 1
fi

echo "📍 Current directory: $(pwd)"
echo "✅ Project files found"
echo ""

# Step 1: Git Setup
echo "🔧 STEP 1: Git Repository Setup"
echo "--------------------------------"

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📝 Initializing new git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git already initialized"
fi

# Configure git user if not set
if [ -z "$(git config user.name)" ]; then
    echo "⚙️ Git user not configured. Please set your name:"
    read -p "Enter your name: " git_name
    git config user.name "$git_name"
fi

if [ -z "$(git config user.email)" ]; then
    echo "⚙️ Git email not configured. Please set your email:"
    read -p "Enter your email: " git_email
    git config user.email "$git_email"
fi

# Step 2: Security Check
echo ""
echo "🔒 STEP 2: Security Verification"
echo "---------------------------------"

# Verify .env is ignored
if [ -f ".env" ]; then
    if git check-ignore .env >/dev/null 2>&1; then
        echo "✅ .env file is properly ignored"
    else
        echo "❌ WARNING: .env file is NOT ignored! Check .gitignore"
        exit 1
    fi
fi

echo "✅ Security checks passed"

# Step 3: Prepare for GitHub
echo ""
echo "📦 STEP 3: Prepare Files for GitHub"
echo "------------------------------------"

# Add all files
git add .

# Show status
echo "📋 Files to be committed:"
git status --short
echo ""

# Create commit
if git diff --cached --quiet; then
    echo "ℹ️ No changes to commit"
else
    echo "💾 Creating commit..."
    git commit -m "🌌 Cosmic Solana Jupiter Swap - Production Ready

✨ Features:
- Secure client-side Phantom wallet signing
- Jupiter API integration for multi-DEX routing
- Beautiful space-themed UI with animations
- Real-time WebSocket confirmations
- Modern React 18 implementation
- Vercel deployment configuration

🔐 Security:
- No server-side private keys
- Client-side transaction signing only
- Production-grade DeFi security standards
- Environment variables properly ignored

🚀 Ready for GitHub and Vercel deployment
📁 Project: Solana DeFi Swap Platform"
    
    echo "✅ Commit created successfully!"
fi

# Step 4: GitHub Instructions
echo ""
echo "🌐 STEP 4: Push to GitHub"
echo "-------------------------"
echo "Now you need to:"
echo ""
echo "1. Create a new repository on GitHub:"
echo "   • Go to https://github.com/new"
echo "   • Repository name: cosmic-solana-swap"
echo "   • Description: Solana DeFi swap platform with Jupiter API"
echo "   • Make it Public (for Vercel free tier)"
echo "   • Don't add README, .gitignore, or license (we have them)"
echo ""
echo "2. Connect and push to GitHub:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/cosmic-solana-swap.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""

# Step 5: Vercel Instructions
echo ""
echo "⚡ STEP 5: Deploy to Vercel"
echo "---------------------------"
echo "After pushing to GitHub:"
echo ""
echo "1. Go to https://vercel.com/"
echo "2. Sign up/Login with GitHub"
echo "3. Click 'New Project'"
echo "4. Import your cosmic-solana-swap repository"
echo "5. Configure environment variables:"
echo "   • RPC_URL: Your Helius or RPC endpoint"
echo "   • (DO NOT add PRIVATE_KEY - not needed for production)"
echo ""
echo "6. Deploy settings (Vercel should auto-detect):"
echo "   • Framework Preset: Other"
echo "   • Build Command: npm run build"
echo "   • Output Directory: (leave empty)"
echo "   • Install Command: npm install"
echo ""

echo "🎯 WHAT HAPPENS NEXT:"
echo "• GitHub will host your source code"
echo "• Vercel will auto-deploy from your GitHub repo"
echo "• Every push to main branch will trigger new deployment"
echo "• Your app will get a https://your-app.vercel.app URL"
echo ""

echo "🔐 SECURITY NOTES:"
echo "• .env file is ignored and won't be pushed to GitHub"
echo "• Set RPC_URL as environment variable in Vercel dashboard"
echo "• No private keys needed for production (secure design)"
echo ""

echo "✅ Ready to deploy! Follow the GitHub and Vercel steps above."