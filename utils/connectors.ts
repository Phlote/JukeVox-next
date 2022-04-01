import { InjectedConnector } from "@web3-react/injected-connector";
import { WalletConnectConnector } from "@web3-react/walletconnect-connector";
import { SupportedChainId } from "./constants";

export const Injected = new InjectedConnector({
  supportedChainIds: [SupportedChainId.RINKEBY],
});

export const WalletConnect = new WalletConnectConnector({
  supportedChainIds: [SupportedChainId.RINKEBY],
  rpc: {
    // 137: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY_POLYGON}`,
    4: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY}`,
  },
  qrcode: true,
});
