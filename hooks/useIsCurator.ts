import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import { NETWORKS, TEST_PHOTE_TOKEN_ADDRESS } from "../constants";
import { parseBalance } from "../util";
import useTokenBalance from "./useTokenBalance";

export const useIsCurator = () => {
  const { account, chainId } = useWeb3React<Web3Provider>();
  const { data } = useTokenBalance(account, TEST_PHOTE_TOKEN_ADDRESS);

  if (chainId !== 137) return false;

  return parseBalance(data ?? 0) > 0;
};
