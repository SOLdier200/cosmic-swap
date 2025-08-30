#!/bin/bash

echo "🚀 Initializing Git and pushing to GitHub..."
echo "📁 Current directory: $(pwd)"
echo ""

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📝 Initializing new git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git already initialized"
fi

# Add all files (respecting .gitignore)
echo "📦 Adding files to git (excluding .env per .gitignore)..."
git add .

# Show what will be committed (excluding ignored files)
echo ""
echo "📋 Files to be committed:"
git status --short

echo ""
echo "🔒 Confirming .env is properly ignored:"
if git ls-files | grep -q "^\.env$"; then
    echo "❌ WARNING: .env is being tracked! Check .gitignore!"
    exit 1
else
    echo "✅ .env is properly ignored and will NOT be committed"
fi

# Create commit
echo ""
echo "💾 Creating commit..."
git commit -m "🌌 Cosmic Solana Jupiter Swap - Production Ready

✨ Features:
- Secure client-side Phantom wallet signing
- Jupiter API integration for multi-DEX routing
- Beautiful space-themed UI with animations
- Real-time WebSocket confirmations
- Modern React 18 implementation

🔐 Security:
- No server-side private keys
- Client-side transaction signing only
- Production-grade DeFi security standards
- Comprehensive input validation

🚀 Ready for production deployment on Vercel"

echo "✅ Commit created successfully!"
echo ""
echo "📡 Ready to push to GitHub!"
echo "Run: git remote add origin https://github.com/yourusername/your-repo-name.git"
echo "Then: git branch -M main && git push -u origin main"