import { TokenInput } from "nft.storage/dist/src/token";
import React, { useEffect } from "react";
import { useMoralis, useMoralisWeb3Api } from "react-moralis";
import { NFT_MINT_CONTRACT_RINKEBY } from "../contracts/addresses";
import { ArchiveCuration } from "../pages/myarchive";
import {
  mappingAttributeToCurationField,
  TokenMetadata,
} from "../types/curations";

// https://github.com/MoralisWeb3/react-moralis/issues/184

export const useMoralisWeb3Ready = () => {
  const Web3Api = useMoralisWeb3Api();

  const [moralisWeb3Ready, setMoralistWeb3Ready] =
    React.useState<boolean>(false);

  React.useEffect(() => {
    Web3Api.Web3API.initialize({
      apiKey: process.env.NEXT_PUBLIC_MORALIS_WEB3_API_KEY,
    });
    setMoralistWeb3Ready(true);
  }, []);

  return moralisWeb3Ready;
};

export const useNFTSearch = (searchTerm) => {
  const Web3Api = useMoralisWeb3Api();
  const isReady = useMoralisWeb3Ready();
  const [searchResults, setResults] = React.useState<ArchiveCuration[]>();

  console.log(searchResults);

  const fetchNFTs = async () => {
    const options = {
      q: searchTerm ?? "",
      filter: "name,description,attributes" as "name,description,attributes",
      chain: "rinkeby" as "rinkeby",
    };
    const { result } = await Web3Api.token.searchNFTs(options);
    // for some reason, moralis search doesnt let you do it for a specific contract. Weird.
    const onlyPhlote = result.filter((nft) => {
      //TODO: make a compare hash function that makes sure they're all lower or upper case
      return nft.token_address === NFT_MINT_CONTRACT_RINKEBY;
    });

    const asMetadata = onlyPhlote.map(
      (nft) => JSON.parse(nft.metadata) as TokenMetadata
    );
    const asAttributes = asMetadata.map((metadata) => metadata.attributes);
    const curations = asAttributes.map((attributes) =>
      attributes.reduce((acc, attr) => {
        acc[mappingAttributeToCurationField[attr.trait_type]] = attr.value;
        return acc;
      }, {} as ArchiveCuration)
    );
    setResults(curations);
  };

  useEffect(() => {
    if (isReady) fetchNFTs();
  }, [isReady]);

  return searchResults;
};
