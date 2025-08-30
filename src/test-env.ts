// src/test-env.ts
import dotenv from 'dotenv';

dotenv.config();

console.log('SOLANA_RPC_URL:', process.env.SOLANA_RPC_URL);
console.log('WALLET_PRIVATE_KEY:', process.env.WALLET_PRIVATE_KEY ? 'Loaded' : 'Missing');
console.log('FEE_WALLET_ADDRESS:', process.env.FEE_WALLET_ADDRESS);