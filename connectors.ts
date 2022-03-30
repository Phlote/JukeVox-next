import { InjectedConnector } from "@web3-react/injected-connector";
import { WalletConnectConnector } from "@web3-react/walletconnect-connector";
import { POLYGON_CHAIN_ID, RINKEBY_CHAIN_ID } from "./constants";

export const injected = new InjectedConnector({
  supportedChainIds: [1, 3, RINKEBY_CHAIN_ID, 5, 42, POLYGON_CHAIN_ID],
});

export const walletConnect = new WalletConnectConnector({
  // rpcUrl: `https://mainnet.infura.io/v3/${process.env.INFURA_KEY}`,
  // bridge: "https://bridge.walletconnect.org",
  qrcode: true,
});
