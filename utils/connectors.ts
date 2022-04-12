import { InjectedConnector } from "@web3-react/injected-connector";
import { WalletConnectConnector } from "@web3-react/walletconnect-connector";
import { SupportedChainId } from "./constants";

export const Injected = new InjectedConnector({
  supportedChainIds: [1, SupportedChainId.RINKEBY, SupportedChainId.POLYGON],
});

export const WalletConnect = new WalletConnectConnector({
  supportedChainIds: [SupportedChainId.RINKEBY, SupportedChainId.POLYGON],
  rpc: {
    [SupportedChainId.POLYGON]: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY_POLYGON}`,
    [SupportedChainId.RINKEBY]: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY}`,
  },
  qrcode: true,
});
