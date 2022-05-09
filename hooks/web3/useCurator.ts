import useContract from "./useContract";

const { NEXT_PUBLIC_CURATOR_CONTRACT_ADDRESS } = process.env;
export const usePhlote = () => {
  return useContract<>(NEXT_PUBLIC_CURATOR_CONTRACT_ADDRESS, PHLOTE_ABI);
};
