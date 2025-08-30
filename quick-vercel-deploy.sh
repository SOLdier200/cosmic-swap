#!/bin/bash

cd /home/soldier/my-solana-swap-isolated

echo "⚡ Quick Vercel CLI Deployment"
echo "=============================="

# Install Vercel CLI
npm install -g vercel

# Login (opens browser)
vercel login

# Deploy with environment variable
echo "Enter your RPC_URL (e.g., https://mainnet.helius-rpc.com/?api-key=YOUR_KEY):"
read -p "RPC_URL: " rpc_url

# Deploy to production
vercel --prod -e RPC_URL="$rpc_url" --yes

echo "🎉 Cosmic Swap deployed!"