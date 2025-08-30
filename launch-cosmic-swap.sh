#!/bin/bash

echo "🌌 Starting Solana Jupiter Swap - Cosmic Edition 🌌"
echo ""

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️  Warning: .env file not found!"
    echo "Please create a .env file with your RPC_URL and PRIVATE_KEY"
    echo ""
fi

echo "🚀 Launching Jupiter Swap UI with cosmic theme..."
echo "🌐 Server will be available at: http://localhost:3000"
echo ""
echo "✨ Features:"
echo "   - Cosmic space theme with animated stars"
echo "   - SOL & USDC balance display"
echo "   - Jupiter API integration (routes through Raydium & others)"
echo "   - Phantom wallet integration"
echo ""

# Start the server
npm run ui
