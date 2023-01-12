export const TEST_PHOTE_TOKEN_ADDRESS =
  "0x31DA0475d29a452DA24Eb2ed0d41AD53E576b780";

export enum SupportedChainId {
  MAINNET = 1,
  // ROPSTEN = 3,
  RINKEBY = 4,
  // GOERLI = 5,
  // KOVAN = 42,

  // ARBITRUM_ONE = 42161,
  // ARBITRUM_RINKEBY = 421611,

  // OPTIMISM = 10,
  // OPTIMISTIC_KOVAN = 69,

  POLYGON = 137,
  POLYGON_MUMBAI = 80001,
}

export const CHAIN_IDS_TO_NAMES = {
  [SupportedChainId.MAINNET]: "mainnet",
  // [SupportedChainId.ROPSTEN]: "ropsten",
  [SupportedChainId.RINKEBY]: "rinkeby",
  // [SupportedChainId.GOERLI]: "goerli",
  // [SupportedChainId.KOVAN]: "kovan",
  [SupportedChainId.POLYGON]: "polygon",
  // [SupportedChainId.POLYGON_MUMBAI]: "polygon_mumbai",
  // [SupportedChainId.ARBITRUM_ONE]: "arbitrum",
  // [SupportedChainId.ARBITRUM_RINKEBY]: "arbitrum_rinkeby",
  // [SupportedChainId.OPTIMISM]: "optimism",
  // [SupportedChainId.OPTIMISTIC_KOVAN]: "optimistic_kovan",
};

export const NETWORKS = {
  polygon: {
    chainId: `0x${SupportedChainId.POLYGON.toString(16)}`,
    chainName: "Polygon Mainnet",
    nativeCurrency: {
      name: "MATIC",
      symbol: "MATIC",
      decimals: 18,
    },
    rpcUrls: ["https://polygon-rpc.com/"],
    blockExplorerUrls: ["https://polygonscan.com/"],
  },
};

export const PHLOTE_SIGNATURE_REQUEST_MESSAGE =
  "Sign this message to prove you have access to this wallet. This won't cost you any gas. \n\n";

export const PHOTE_VOTE_TOKEN_ADDRESS =
  "0xc973F97a608b4E282EB97C7E86901ab5EBf3A014";

export const Web3_Socket_URL = `wss://polygon-mumbai.g.alchemy.com/v2/+ ${process.env.NEXT_PUBLIC_ALCHEMY_APIKEY}`
