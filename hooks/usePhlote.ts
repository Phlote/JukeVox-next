import { NFT_MINT_CONTRACT_RINKLEBY } from "../contracts/addresses";
import useContract from "./useContract";
import PHLOTE_ABI from "../contracts/Phlote.json";
import { Phlote } from "../contracts/types";

export const usePhlote = () => {
  return useContract<Phlote>(NFT_MINT_CONTRACT_RINKLEBY, PHLOTE_ABI);
};
