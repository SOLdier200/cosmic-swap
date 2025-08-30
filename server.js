const express = require('express');
const path = require('path');
const cors = require('cors');
require('dotenv').config();

// Use ts-node to import TypeScript files
require('ts-node').register({
    transpileOnly: true,
    compilerOptions: {
        module: 'commonjs'
    }
});

const { JupiterSwap } = require('./src/index.ts');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(cors());
app.use(express.static('public'));

// Initialize connection only (no private key needed for read operations)
let connection;

async function initializeConnection() {
    try {
        const RPC_URL = process.env.RPC_URL || "https://api.mainnet-beta.solana.com";
        connection = new (require('@solana/web3.js')).Connection(RPC_URL);
        console.log('✅ RPC Connection initialized');
        return connection;
    } catch (error) {
        console.error('❌ Failed to initialize connection:', error);
        return null;
    }
}

// API Routes

// Get token balance (for USDC, etc.)
app.post('/api/token-balance', async (req, res) => {
    try {
        const { wallet, mint } = req.body;
        if (!wallet || !mint) {
            return res.status(400).json({ error: 'Wallet address and mint required' });
        }

        const { Connection, PublicKey } = require('@solana/web3.js');
        const { TOKEN_PROGRAM_ID } = require('@solana/spl-token');
        
        // Use the initialized connection
        if (!connection) {
            return res.status(500).json({ error: 'RPC connection not initialized' });
        }
        
        // Get token accounts for this wallet
        const tokenAccounts = await connection.getTokenAccountsByOwner(
            new PublicKey(wallet),
            { mint: new PublicKey(mint) }
        );

        let balance = '0.00';
        if (tokenAccounts.value.length > 0) {
            const accountInfo = await connection.getAccountInfo(tokenAccounts.value[0].pubkey);
            if (accountInfo) {
                // Decode token account data
                const { AccountLayout } = require('@solana/spl-token');
                const tokenAccountData = AccountLayout.decode(accountInfo.data);
                const tokenBalance = Number(tokenAccountData.amount);
                
                // USDC has 6 decimals
                const decimals = mint === 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v' ? 6 : 6;
                balance = (tokenBalance / Math.pow(10, decimals)).toFixed(2);
            }
        }

        res.json({ 
            success: true, 
            balance: balance,
            mint: mint
        });
    } catch (error) {
        console.error('Token balance error:', error);
        res.status(500).json({ error: error.message });
    }
});
app.post('/api/balance', async (req, res) => {
    try {
        const { wallet } = req.body;
        if (!wallet) {
            return res.status(400).json({ error: 'Wallet address required' });
        }

        // Get SOL balance using the initialized connection
        if (!connection) {
            return res.status(500).json({ error: 'RPC connection not initialized' });
        }
        
        const balance = await connection.getBalance(new (require('@solana/web3.js')).PublicKey(wallet));
        const solBalance = (balance / 1e9).toFixed(4);

        res.json({ 
            success: true, 
            balance: solBalance,
            lamports: balance 
        });
    } catch (error) {
        console.error('Balance error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Note: Server-side swap endpoints removed for security
// All swaps now handled client-side with Phantom wallet signing
// This eliminates the need for private keys on the server

// Get supported tokens
app.get('/api/tokens', (req, res) => {
    const tokens = {
        SOL: {
            mint: 'So11111111111111111111111111111111111111112',
            symbol: 'SOL',
            name: 'Solana',
            decimals: 9,
            logoURI: 'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/So11111111111111111111111111111111111111112/logo.png'
        },
        USDC: {
            mint: 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v',
            symbol: 'USDC',
            name: 'USD Coin',
            decimals: 6,
            logoURI: 'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v/logo.png'
        },
        RAY: {
            mint: '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R',
            symbol: 'RAY',
            name: 'Raydium',
            decimals: 6,
            logoURI: 'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R/logo.png'
        },
        USDT: {
            mint: 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB',
            symbol: 'USDT',
            name: 'Tether USD',
            decimals: 6,
            logoURI: 'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB/logo.svg'
        }
    };
    
    res.json({ success: true, tokens });
});

// Health check
app.get('/api/health', (req, res) => {
    res.json({ 
        success: true, 
        status: 'Server running',
        network: 'mainnet',
        rpc: process.env.RPC_URL || "https://api.mainnet-beta.solana.com"
    });
});

// Serve the main UI
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Error handling middleware
app.use((error, req, res, next) => {
    console.error('Server error:', error);
    res.status(500).json({ 
        success: false, 
        error: 'Internal server error' 
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({ 
        success: false, 
        error: 'Route not found' 
    });
});

// Start server
async function startServer() {
    try {
        // Initialize RPC connection (no private key needed)
        await initializeConnection();
        
        app.listen(PORT, () => {
            console.log(`\n🚀 Solana Jupiter Swap UI Server started!`);
            console.log(`📱 Open your browser to: http://localhost:${PORT}`);
            console.log(`🌐 Network: Mainnet`);
            console.log(`🔗 RPC: ${process.env.RPC_URL}`);
            console.log(`🔒 Security: Client-side signing only (no private keys on server)`);
            console.log(`⚡ Swap Engine: Jupiter API + Phantom Wallet`);
            console.log(`\n💡 Security Features:`);
            console.log(`   - Private keys never stored on server`);
            console.log(`   - All transactions signed by user's Phantom wallet`);
            console.log(`   - Server only provides read-only RPC access\n`);
        });
    } catch (error) {
        console.error('❌ Failed to start server:', error);
        process.exit(1);
    }
}

// Handle graceful shutdown
process.on('SIGTERM', () => {
    console.log('👋 Server shutting down gracefully...');
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('👋 Server shutting down gracefully...');
    process.exit(0);
});

startServer();