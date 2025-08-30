# 🌌 Cosmic Solana Swap - Jupiter DeFi Platform

A secure, production-ready Solana token swap platform powered by Jupiter API with a beautiful cosmic space theme.

## ✨ Features

- **🔐 Secure Architecture**: Client-side Phantom wallet signing (no server-side private keys)
- **⚡ Jupiter Integration**: Multi-DEX routing through Jupiter's aggregated liquidity
- **🎨 Cosmic UI**: Beautiful space-themed interface with animated stars and nebula effects
- **📱 Responsive Design**: Works perfectly on desktop and mobile
- **🚀 Real-time Updates**: WebSocket confirmations and live balance updates
- **⚙️ Modern Stack**: React 18, TypeScript, Tailwind CSS, Node.js

## 🚀 Live Demo

**Deployed on Vercel**: [Your Vercel URL here]

## 🛠️ Technology Stack

### Frontend
- **React 18** with createRoot API
- **Tailwind CSS** for responsive design
- **Phantom Wallet** integration
- **Jupiter API** for swap routing
- **Custom CSS** animations for space theme

### Backend  
- **Node.js + Express** server
- **TypeScript** support
- **Solana Web3.js** for blockchain interactions
- **CORS** enabled for cross-origin requests

### Infrastructure
- **Helius RPC** with WebSocket support
- **Jupiter API** integration
- **Vercel** deployment

## 🔒 Security Features

✅ **No Private Keys on Server** - All transactions signed client-side  
✅ **Phantom Wallet Integration** - User controls their keys  
✅ **Read-only RPC Access** - Server only checks balances  
✅ **Input Validation** - All user inputs sanitized  
✅ **Environment Variables** - Sensitive data properly managed  

## 🏃‍♂️ Quick Start

### Prerequisites
- Node.js v14 or higher
- Phantom wallet browser extension
- Solana RPC endpoint (Helius recommended)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/cosmic-solana-swap.git
   cd cosmic-solana-swap
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your RPC_URL
   ```

4. **Start the application**
   ```bash
   npm start
   ```

5. **Open your browser**
   ```
   http://localhost:3000
   ```

## 🌍 Deployment

### Vercel Deployment (Recommended)

1. **Push to GitHub** (this repository)

2. **Deploy to Vercel**:
   - Connect your GitHub repository
   - Set environment variables:
     - `RPC_URL`: Your Solana RPC endpoint

3. **Environment Variables**:
   ```
   RPC_URL=https://mainnet.helius-rpc.com/?api-key=YOUR_API_KEY
   ```

### Manual Deployment

```bash
# Build the project
npm run build

# Start production server
npm start
```

## 🎯 Supported Operations

- **Token Swaps**: SOL ↔ USDC, RAY, USDT via Jupiter routing
- **Balance Checking**: Real-time SOL and SPL token balances  
- **Transaction Simulation**: Preview swap outcomes before execution
- **Wallet Integration**: Phantom wallet connection and signing

## 📊 API Endpoints

- `POST /api/balance` - Get SOL balance for wallet address
- `POST /api/token-balance` - Get SPL token balance  
- `GET /api/tokens` - Retrieve supported token list
- `GET /api/health` - Server health check

## 🔧 Configuration

### Environment Variables

```bash
# Required
RPC_URL=https://api.mainnet-beta.solana.com

# Optional (for enhanced features)
RPC_URL=https://mainnet.helius-rpc.com/?api-key=YOUR_KEY
```

### Supported Networks
- **Mainnet** (Production)
- **Devnet** (Development) 

### Supported Tokens
- SOL (Solana)
- USDC (USD Coin)
- RAY (Raydium)
- USDT (Tether USD)

## 📱 User Interface

### Swap Interface
- Visual token selection with logos
- Real-time price quotes
- Adjustable slippage tolerance
- Transaction progress tracking

### Wallet Features  
- One-click Phantom wallet connection
- Balance display for connected wallet
- Copy wallet address functionality
- Transaction history links

### Visual Design
- Space/cosmic theme with animated stars
- Dark gradient backgrounds with nebula effects
- Glass morphism containers
- Responsive card-based layout

## 🧪 Development

### Scripts
- `npm start` - Start production server
- `npm run dev` - Start development mode  
- `npm run build` - Build TypeScript files
- `npm run ui` - Start UI server

### File Structure
```
cosmic-solana-swap/
├── public/           # Frontend assets
│   └── index.html   # Main UI application
├── src/             # Backend source code
│   └── index.ts     # Jupiter swap logic
├── server.js        # Express server
├── package.json     # Dependencies
├── vercel.json      # Vercel configuration
└── README.md        # This file
```

## 🛡️ Security Best Practices

- **Client-Side Signing**: All transactions require user approval via Phantom wallet
- **No Private Keys**: Server never accesses or stores private keys  
- **Environment Security**: Sensitive configuration properly managed
- **Input Validation**: All user inputs sanitized and validated
- **HTTPS Only**: All external API calls use encrypted connections

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

For support and questions:
- Open an issue on GitHub
- Check the [Project Briefing](PROJECT-BRIEFING-COMPLETE.md) for detailed documentation

## 🌟 Acknowledgments

- **Jupiter Protocol** for providing excellent swap aggregation
- **Solana Foundation** for the robust blockchain infrastructure  
- **Phantom Wallet** for secure wallet integration
- **Vercel** for seamless deployment platform

---

**⚡ Powered by Jupiter • 🔒 Secured by Phantom • 🌌 Themed by the Cosmos**