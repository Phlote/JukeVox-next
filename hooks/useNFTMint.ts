import { NFT_MINT_CONTRACT_RINKLEBY } from "../contracts/addresses";
import useContract from "./useContract";
import NFT_MINT_ABI from "../contracts/NFTMint.json";
import { NFTMint } from "../contracts/types";

export const useNFTMint = () => {
  return useContract<NFTMint>(NFT_MINT_CONTRACT_RINKLEBY, NFT_MINT_ABI);
};
