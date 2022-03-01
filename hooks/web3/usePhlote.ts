import { NFT_MINT_CONTRACT_RINKEBY } from "../../contracts/addresses";
import useContract from "./useContract";
import PHLOTE_ABI from "../../contracts/Phlote.json";
import { Phlote } from "../../contracts/types";

export const usePhlote = () => {
  return useContract<Phlote>(NFT_MINT_CONTRACT_RINKEBY, PHLOTE_ABI);
};
