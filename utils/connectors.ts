import { InjectedConnector } from "@web3-react/injected-connector";
import { WalletConnectConnector } from "@web3-react/walletconnect-connector";

const SUPPORTED_CHAIN_IDS = [4];

export const Injected = new InjectedConnector({
  supportedChainIds: SUPPORTED_CHAIN_IDS,
});

export const WalletConnect = new WalletConnectConnector({
  supportedChainIds: SUPPORTED_CHAIN_IDS,
  rpc: {
    // 137: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY_POLYGON}`,
    4: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY}`,
  },
  qrcode: true,
});
