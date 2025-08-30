#!/bin/bash

echo "🌌 COSMIC SWAP - Git Setup & GitHub Push"
echo "========================================="
echo ""

# Make sure we're in the right directory
cd /home/soldier/my-solana-swap-isolated

echo "📍 Current directory: $(pwd)"
echo ""

# Step 1: Initialize Git
echo "🔧 STEP 1: Initialize Git Repository"
echo "-------------------------------------"
git init
echo "✅ Git repository initialized"
echo ""

# Step 2: Configure Git User (if not already set globally)
echo "⚙️ STEP 2: Configure Git User"
echo "------------------------------"

# Check if git user is configured globally
if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
    echo "Setting up git user configuration..."
    git config user.name "SOLdier200"
    git config user.email "soldier200@example.com"
    echo "✅ Git user configured locally"
else
    echo "✅ Git user already configured globally"
fi

# Step 3: Security Check - Verify .env is ignored
echo ""
echo "🔒 STEP 3: Security Verification"
echo "---------------------------------"

if [ -f ".env" ]; then
    if git check-ignore .env >/dev/null 2>&1; then
        echo "✅ .env file is properly ignored by git"
    else
        echo "⚠️ Adding .env to be ignored..."
        echo ".env" >> .gitignore
        echo "✅ .env now properly ignored"
    fi
fi

# Step 4: Add Files to Git
echo ""
echo "📦 STEP 4: Add Files to Git"
echo "----------------------------"
git add .

echo "📋 Files added to git staging:"
git status --short
echo ""

# Step 5: Create Initial Commit
echo "💾 STEP 5: Create Initial Commit"
echo "---------------------------------"
git commit -m "🌌 Initial commit: Cosmic Solana Swap Platform

✨ Features:
- Secure Jupiter API integration for multi-DEX swaps
- Beautiful cosmic space-themed UI with animations
- Client-side Phantom wallet signing (no server keys)
- Real-time WebSocket confirmations
- Modern React 18 + TypeScript implementation
- Production-ready Vercel deployment config

🔐 Security:
- No private keys stored on server
- Environment variables properly ignored
- Client-side transaction signing only

🚀 Ready for GitHub and Vercel deployment!"

echo "✅ Initial commit created!"
echo ""

# Step 6: Add GitHub Remote and Push
echo "🌐 STEP 6: Connect to GitHub and Push"
echo "--------------------------------------"

# Add the remote
git remote add origin https://github.com/SOLdier200/cosmic-swap.git
echo "✅ GitHub remote added"

# Set main branch
git branch -M main
echo "✅ Main branch set"

# Push to GitHub
echo "📡 Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Your project is now on GitHub!"
    echo "🔗 Repository URL: https://github.com/SOLdier200/cosmic-swap"
    echo ""
    echo "🚀 NEXT STEP: Deploy to Vercel"
    echo "-------------------------------"
    echo "1. Go to https://vercel.com/"
    echo "2. Sign in with GitHub"
    echo "3. Click 'New Project'"
    echo "4. Import 'SOLdier200/cosmic-swap'"
    echo "5. Set environment variable:"
    echo "   RPC_URL = https://mainnet.helius-rpc.com/?api-key=YOUR_KEY"
    echo "6. Deploy!"
    echo ""
    echo "✅ Your Cosmic Swap will be live at: https://cosmic-swap.vercel.app"
else
    echo "❌ Push failed. Please check your GitHub authentication."
    echo "💡 You might need to authenticate with GitHub first."
fi