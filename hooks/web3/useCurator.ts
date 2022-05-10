import CURATOR_ABI from "../../solidity/artifacts/contracts/Curator.sol/Curator.json";
import type { Curator } from "../../solidity/typechain";
import useContract from "./useContract";

const { NEXT_PUBLIC_CURATOR_CONTRACT_ADDRESS } = process.env;

export const useCurator = () => {
  return useContract<Curator>(
    NEXT_PUBLIC_CURATOR_CONTRACT_ADDRESS,
    CURATOR_ABI
  );
};
