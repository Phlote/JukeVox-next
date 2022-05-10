import CURATOR_ABI from "../../contracts/Curator.json";
import { Curator } from "../../contracts/types";
import useContract from "./useContract";

const { NEXT_PUBLIC_CURATOR_CONTRACT_ADDRESS } = process.env;

export const useCurator = () => {
  return useContract<Curator>(
    NEXT_PUBLIC_CURATOR_CONTRACT_ADDRESS,
    CURATOR_ABI
  );
};
