import PHLOTE_VOTE_ABI from "../../solidity/artifacts/contracts/PhloteVote.sol/PhloteVote.json";
import type { PhloteVote } from "../../solidity/typechain";
import useContract from "./useContract";

const { NEXT_PUBLIC_PHLOTE_VOTE_ADDRESS } = process.env;

export const usePhloteVote = () => {
  return useContract<PhloteVote>(
    NEXT_PUBLIC_PHLOTE_VOTE_ADDRESS,
    PHLOTE_VOTE_ABI.abi
  );
};
