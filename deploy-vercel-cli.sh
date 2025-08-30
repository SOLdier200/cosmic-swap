#!/bin/bash

echo "⚡ COSMIC SWAP - Vercel CLI Deployment"
echo "======================================"
echo ""

# Make sure we're in the project directory
cd /home/soldier/my-solana-swap-isolated

echo "📍 Current directory: $(pwd)"
echo ""

# Step 1: Check if git is set up
echo "🔍 STEP 1: Checking Git Status"
echo "-------------------------------"

if [ ! -d ".git" ]; then
    echo "❌ Git not initialized. Let's fix that first..."
    
    # Initialize git
    git init
    echo "✅ Git initialized"
    
    # Configure git user
    git config user.name "SOLdier200"
    git config user.email "soldier200@example.com"
    echo "✅ Git user configured"
    
    # Add files and commit
    git add .
    git commit -m "🌌 Initial commit: Cosmic Solana Swap Platform

✨ Features:
- Secure Jupiter API integration for multi-DEX swaps
- Beautiful cosmic space-themed UI with animations
- Client-side Phantom wallet signing (no server keys)
- Real-time WebSocket confirmations
- Modern React 18 + TypeScript implementation

🔐 Security:
- No private keys stored on server
- Environment variables properly ignored
- Client-side transaction signing only

🚀 Ready for Vercel deployment!"
    
    echo "✅ Initial commit created"
    
    # Add GitHub remote
    git remote add origin https://github.com/SOLdier200/cosmic-swap.git
    git branch -M main
    
    echo "📡 Pushing to GitHub first..."
    git push -u origin main
    
    if [ $? -ne 0 ]; then
        echo "⚠️ GitHub push failed. Continuing with Vercel deployment..."
        echo "💡 You can link to GitHub later in Vercel dashboard"
    else
        echo "✅ Successfully pushed to GitHub!"
    fi
else
    echo "✅ Git repository already exists"
    
    # Check if we have unpushed changes
    if git status --porcelain | grep -q .; then
        echo "📦 Found uncommitted changes, committing them..."
        git add .
        git commit -m "🚀 Pre-deployment update: Ready for Vercel CLI deployment"
        
        # Try to push if remote exists
        if git remote get-url origin >/dev/null 2>&1; then
            git push
            echo "✅ Changes pushed to GitHub"
        fi
    else
        echo "✅ No uncommitted changes"
    fi
fi

echo ""

# Step 2: Install Vercel CLI
echo "⬇️ STEP 2: Install Vercel CLI"
echo "------------------------------"

if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI globally..."
    npm install -g vercel
    echo "✅ Vercel CLI installed!"
else
    echo "✅ Vercel CLI already installed"
fi

echo ""

# Step 3: Login to Vercel
echo "🔐 STEP 3: Vercel Authentication"
echo "---------------------------------"
echo "💡 You'll need to login to Vercel. This will open your browser."
echo "Press Enter to continue..."
read -r

vercel login

echo ""

# Step 4: Project Setup
echo "⚙️ STEP 4: Project Configuration"
echo "---------------------------------"

# Create vercel project configuration if it doesn't exist
if [ ! -f "vercel.json" ]; then
    echo "📝 Creating vercel.json configuration..."
    cat > vercel.json << EOF
{
  "version": 2,
  "name": "cosmic-swap",
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/server.js"
    },
    {
      "src": "/(.*)",
      "dest": "/server.js"
    }
  ],
  "env": {
    "NODE_ENV": "production"
  },
  "functions": {
    "server.js": {
      "maxDuration": 30
    }
  }
}
EOF
    echo "✅ vercel.json created"
else
    echo "✅ vercel.json already exists"
fi

echo ""

# Step 5: Environment Variables Setup
echo "🔧 STEP 5: Environment Variables"
echo "---------------------------------"
echo "💡 You need to set your RPC_URL for the production environment."
echo ""
echo "Please enter your production RPC URL:"
echo "Example: https://mainnet.helius-rpc.com/?api-key=YOUR_KEY"
echo "Or press Enter to skip and set it later in Vercel dashboard"
echo ""
read -p "RPC_URL: " rpc_url

echo ""

# Step 6: Deploy to Vercel
echo "🚀 STEP 6: Deploy to Vercel"
echo "----------------------------"

echo "🌌 Deploying Cosmic Swap to Vercel..."
echo ""

if [ -n "$rpc_url" ]; then
    # Deploy with environment variable
    echo "📡 Deploying with RPC_URL environment variable..."
    vercel --prod -e RPC_URL="$rpc_url" --yes
else
    # Deploy without environment variable
    echo "📡 Deploying (you'll need to set RPC_URL in dashboard)..."
    vercel --prod --yes
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Cosmic Swap is now live on Vercel!"
    echo ""
    echo "🌐 Your app is deployed at:"
    echo "https://cosmic-swap.vercel.app (or similar URL shown above)"
    echo ""
    echo "🔧 Next Steps:"
    echo "1. Test your deployed app"
    echo "2. If you skipped RPC_URL, set it in Vercel dashboard:"
    echo "   • Go to vercel.com/dashboard"
    echo "   • Select your cosmic-swap project"
    echo "   • Go to Settings > Environment Variables"
    echo "   • Add: RPC_URL = your-rpc-endpoint"
    echo ""
    echo "🎯 Features ready:"
    echo "✅ Phantom wallet integration"
    echo "✅ Jupiter API swaps"
    echo "✅ Cosmic space theme"
    echo "✅ Real-time balance updates"
    echo "✅ Mobile responsive design"
    echo ""
    echo "🔗 Manage your deployment:"
    echo "• Dashboard: https://vercel.com/dashboard"
    echo "• Analytics: Built into Vercel dashboard"
    echo "• Custom domain: Configure in project settings"
else
    echo "❌ Deployment failed. Please check the error messages above."
    echo ""
    echo "💡 Common fixes:"
    echo "1. Make sure you're logged into Vercel: vercel login"
    echo "2. Check your internet connection"
    echo "3. Verify vercel.json configuration"
    echo "4. Try deploying again: vercel --prod"
fi

echo ""
echo "🌌 Cosmic Swap deployment script completed!"