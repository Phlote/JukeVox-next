import React, { useEffect } from "react";
import { useMoralis, useMoralisWeb3Api } from "react-moralis";
import { NFT_MINT_CONTRACT_RINKEBY } from "../contracts/addresses";

// https://github.com/MoralisWeb3/react-moralis/issues/184

export const useNFTSearch = () => {
  const { isInitialized } = useMoralis();
  const Web3Api = useMoralisWeb3Api();
  const [moralisWeb3Ready, setMoralistWeb3Ready] =
    React.useState<boolean>(false);

  const fetchNFTs = async () => {
    const options = {
      chain: "rinkeby" as "rinkeby",
      address: NFT_MINT_CONTRACT_RINKEBY,
    };
    // const res = await Web3Api.token.getAllTokenIds(options);
    const res = await Web3Api.token.searchNFTs(options);
    // console.log(res);
  };

  useEffect(() => {
    if (moralisWeb3Ready) fetchNFTs();
  }, [moralisWeb3Ready]);

  React.useEffect(() => {
    Web3Api.Web3API.initialize({
      apiKey: process.env.NEXT_PUBLIC_MORALIS_WEB3_API_KEY,
    });
    setMoralistWeb3Ready(true);
    //TODO: need check initialized?
  }, []);
};
