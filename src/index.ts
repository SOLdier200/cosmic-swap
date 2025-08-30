import {
  Connection,
  Keypair,
  PublicKey,
  Transaction,
  VersionedTransaction,
  sendAndConfirmTransaction,
  ComputeBudgetProgram,
} from '@solana/web3.js';
import axios from 'axios';
import bs58 from 'bs58';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Configuration
interface SwapConfig {
  executeSwap: boolean;
  useVersionedTransaction: boolean;
  tokenAAmount: number;
  tokenAAddress: string;
  tokenBAddress: string;
  slippageBps: number;
  maxRetries: number;
}

const swapConfig: SwapConfig = {
  executeSwap: false, // Set to true to actually execute the swap
  useVersionedTransaction: true,
  tokenAAmount: 0.01, // Amount of SOL to swap
  tokenAAddress: "So11111111111111111111111111111111111111112", // SOL
  tokenBAddress: "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v", // USDC
  slippageBps: 50, // 0.5% slippage
  maxRetries: 10
};

// Environment setup
const RPC_URL = process.env.RPC_URL || "https://api.mainnet-beta.solana.com";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "";

class JupiterSwap {
  private connection: Connection;
  private wallet: Keypair;

  constructor(rpcUrl: string, walletPrivateKey: string) {
    this.connection = new Connection(rpcUrl, 'confirmed');
    this.wallet = Keypair.fromSecretKey(bs58.decode(walletPrivateKey));
  }

  async getQuote(inputMint: string, outputMint: string, amount: number, slippageBps: number = 50) {
    try {
      console.log(`Getting Jupiter quote for ${amount} lamports...`);
      
      const response = await axios.get('https://quote-api.jup.ag/v6/quote', {
        params: {
          inputMint,
          outputMint,
          amount: amount.toString(),
          slippageBps,
          onlyDirectRoutes: false,
          asLegacyTransaction: !swapConfig.useVersionedTransaction
        }
      });

      console.log('Jupiter quote received:', {
        inputAmount: response.data.inAmount,
        outputAmount: response.data.outAmount,
        priceImpactPct: response.data.priceImpactPct,
        routePlan: response.data.routePlan?.length || 0 + ' routes'
      });

      return response.data;
    } catch (error) {
      console.error('Failed to get Jupiter quote:', error);
      throw error;
    }
  }

  async getSwapTransaction(quoteResponse: any) {
    try {
      console.log('Getting swap transaction from Jupiter...');
      
      const response = await axios.post('https://quote-api.jup.ag/v6/swap', {
        quoteResponse,
        userPublicKey: this.wallet.publicKey.toString(),
        wrapAndUnwrapSol: true,
        useSharedAccounts: true,
        feeAccount: undefined,
        computeUnitPriceMicroLamports: 'auto',
        asLegacyTransaction: !swapConfig.useVersionedTransaction
      });

      const swapTransactionBuf = Buffer.from(response.data.swapTransaction, 'base64');
      
      let transaction;
      if (swapConfig.useVersionedTransaction) {
        transaction = VersionedTransaction.deserialize(swapTransactionBuf);
      } else {
        transaction = Transaction.from(swapTransactionBuf);
      }

      return transaction;
    } catch (error) {
      console.error('Failed to get swap transaction:', error);
      throw error;
    }
  }

  async simulateTransaction(transaction: Transaction | VersionedTransaction) {
    try {
      console.log('Simulating transaction...');
      const result = await this.connection.simulateTransaction(transaction as any);
      
      if (result.value.err) {
        console.error('Simulation failed:', result.value.err);
        throw new Error(`Simulation failed: ${JSON.stringify(result.value.err)}`);
      }

      console.log('Simulation successful:', {
        computeUnitsUsed: result.value.unitsConsumed,
        logs: result.value.logs?.slice(-3) // Last 3 logs
      });
      
      return result;
    } catch (error) {
      console.error('Simulation error:', error);
      throw error;
    }
  }

  async sendTransaction(transaction: Transaction | VersionedTransaction) {
    try {
      console.log('Sending transaction...');
      
      let txid: string;
      
      if (transaction instanceof VersionedTransaction) {
        // Sign the versioned transaction
        transaction.sign([this.wallet]);
        
        // Send versioned transaction
        txid = await this.connection.sendTransaction(transaction, {
          skipPreflight: false,
          maxRetries: swapConfig.maxRetries,
        });
      } else {
        // Send legacy transaction
        txid = await this.connection.sendTransaction(transaction, [this.wallet], {
          skipPreflight: false,
          maxRetries: swapConfig.maxRetries,
        });
      }

      console.log('Transaction sent:', txid);
      
      // Wait for confirmation
      const confirmation = await this.connection.confirmTransaction(txid, 'confirmed');
      console.log('Transaction confirmed:', confirmation);
      
      return txid;
    } catch (error) {
      console.error('Transaction failed:', error);
      throw error;
    }
  }

  async performSwap() {
    try {
      console.log('Starting Jupiter swap process...');
      console.log('Wallet public key:', this.wallet.publicKey.toBase58());
      console.log('Configuration:', swapConfig);

      // Convert SOL amount to lamports
      const amountInLamports = Math.floor(swapConfig.tokenAAmount * 1e9);
      console.log(`Swapping ${swapConfig.tokenAAmount} SOL (${amountInLamports} lamports)`);

      // Step 1: Get quote from Jupiter
      const quoteResponse = await this.getQuote(
        swapConfig.tokenAAddress,
        swapConfig.tokenBAddress,
        amountInLamports,
        swapConfig.slippageBps
      );

      // Display quote information
      const inputAmount = parseFloat(quoteResponse.inAmount) / 1e9; // SOL
      const outputAmount = parseFloat(quoteResponse.outAmount) / 1e6; // USDC (6 decimals)
      
      console.log('Quote details:');
      console.log(`  Input: ${inputAmount} SOL`);
      console.log(`  Output: ${outputAmount} USDC`);
      console.log(`  Price Impact: ${quoteResponse.priceImpactPct}%`);
      console.log(`  Route Plans: ${quoteResponse.routePlan?.length || 0}`);

      // Step 2: Get swap transaction
      const swapTransaction = await this.getSwapTransaction(quoteResponse);

      // Step 3: Simulate the transaction
      await this.simulateTransaction(swapTransaction);
      console.log('✅ Simulation successful');

      if (swapConfig.executeSwap) {
        // Step 4: Execute the swap
        console.log('Executing swap...');
        const txid = await this.sendTransaction(swapTransaction);
        
        console.log('✅ Swap completed successfully!');
        console.log(`Transaction ID: ${txid}`);
        console.log(`View on Solscan: https://solscan.io/tx/${txid}`);
        
        return { success: true, txid, inputAmount, outputAmount };
      } else {
        console.log('✅ Swap simulation completed successfully');
        console.log('Set executeSwap to true to perform the actual swap');
        
        return { success: true, simulated: true, inputAmount, outputAmount };
      }

    } catch (error) {
      console.error('Swap failed:', error);
      throw error;
    }
  }
}

// Main execution
async function main() {
  try {
    if (!PRIVATE_KEY || PRIVATE_KEY === "") {
      console.error('❌ Please set your PRIVATE_KEY in the .env file');
      console.log('Create a .env file in your project root with:');
      console.log('RPC_URL=https://api.mainnet-beta.solana.com');
      console.log('PRIVATE_KEY=your_private_key_here');
      return;
    }

    console.log(`🚀 Using RPC: ${RPC_URL}`);

    const jupiterSwap = new JupiterSwap(RPC_URL, PRIVATE_KEY);
    const result = await jupiterSwap.performSwap();
    
    console.log('Final result:', result);
  } catch (error) {
    console.error('Main execution failed:', error);
  }
}

// Run the script only if called directly
if (require.main === module) {
  main();
}

// Exports for use in other files
module.exports = {
  JupiterSwap,
  swapConfig,
  main
};

// ES6 exports for TypeScript compatibility
export { JupiterSwap, swapConfig };