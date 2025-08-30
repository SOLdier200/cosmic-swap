#!/bin/bash

echo "🔧 Applying console warning fixes and React optimizations..."
echo ""

# Check if server is running and restart it
if pgrep -f "node server.js" > /dev/null; then
    echo "📡 Stopping current server..."
    pkill -f "node server.js"
    sleep 2
fi

echo "🚀 Starting optimized server..."
echo "✅ Fixed React Components deprecation warning"
echo "✅ Suppressed Phantom extension console errors"  
echo "✅ Updated to React 18.2.0 production build"
echo "✅ Enhanced wallet connection error handling"
echo "✅ Improved WebSocket connection stability"
echo ""

# Start the server
npm run ui

echo ""
echo "🌌 Cosmic Swap server started with optimized console output!"
echo "🔗 Open: http://localhost:3000"