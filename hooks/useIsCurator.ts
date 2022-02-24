import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import React from "react";
import { useQuery, useQueryClient } from "react-query";
import { NETWORKS, TEST_PHOTE_TOKEN_ADDRESS } from "../constants";
import { nextApiRequest, parseBalance } from "../util";
import useTokenBalance from "./useTokenBalance";

export const useIsCurator = () => {
  const { account } = useWeb3React();

  const cacheKey = ["is-curator", account];
  return useQuery(
    cacheKey,
    async () => {
      if (account)
        return nextApiRequest(`is-curator`, "POST", {
          wallet: account,
        }) as Promise<{
          isCurator: boolean;
        }>;
      else return false;
    },
    { refetchOnWindowFocus: false }
  );
};
