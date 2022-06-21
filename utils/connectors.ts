import { InjectedConnector } from "@web3-react/injected-connector";
import { WalletConnectConnector } from "@web3-react/walletconnect-connector";
import { SupportedChainId } from "./constants";

export const Injected = new InjectedConnector({
  supportedChainIds: [
    SupportedChainId.HARDHAT,
    SupportedChainId.MAINNET,
    SupportedChainId.RINKEBY,
    SupportedChainId.POLYGON,
    SupportedChainId.POLYGON_MUMBAI,
  ],
});

export const WalletConnect = new WalletConnectConnector({
  supportedChainIds: [
    // SupportedChainId.MAINNET,
    SupportedChainId.HARDHAT,
    SupportedChainId.RINKEBY,
    SupportedChainId.POLYGON,
    SupportedChainId.POLYGON_MUMBAI,
  ],
  bridge: "https://bridge.walletconnect.org",
  rpc: {
    // [SupportedChainId.MAINNET]: `https://eth-mainnet.alchemyapi.io/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY_MAINNET}`,
    [SupportedChainId.HARDHAT]: "http://127.0.0.1:8545/",
    [SupportedChainId.POLYGON]: `https://polygon-mainnet.infura.io/v3/${process.env.NEXT_PUBLIC_INFURA_API_KEY}`,
    [SupportedChainId.POLYGON_MUMBAI]: `https://polygon-mumbai.infura.io/v3/${process.env.NEXT_PUBLIC_INFURA_API_KEY}`,
    [SupportedChainId.RINKEBY]: `https://rinkeby.infura.io/v3/${process.env.NEXT_PUBLIC_INFURA_API_KEY}`,
  },
  qrcode: true,
});
