export const TEST_PHOTE_TOKEN_ADDRESS =
  "0x31DA0475d29a452DA24Eb2ed0d41AD53E576b780";

export const RINKEBY_CHAIN_ID = 4;
export const POLYGON_CHAIN_ID = 137;

export const NETWORKS = {
  polygon: {
    chainId: `0x${Number(POLYGON_CHAIN_ID).toString(16)}`,
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

export const PhloteSignatureMessage =
  "Hi there from Phlote! Sign this message to prove you have access to this wallet and we'll log you in. This won't cost you any gas. \n\n";
