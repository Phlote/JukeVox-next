import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import React from "react";
import { useQuery, useQueryClient } from "react-query";
import { NETWORKS, TEST_PHOTE_TOKEN_ADDRESS } from "../constants";
import { nextApiRequest, parseBalance } from "../util";
import useTokenBalance from "./useTokenBalance";

export const useIsCurator = () => {
  const { account } = useWeb3React();
  // TODO not sure if neccesary, will test
  // const queryClient = useQueryClient();

  // React.useEffect(() => {
  //   if (queryClient && account) queryClient.invalidateQueries("is-curator");
  // }, [account]);

  const cacheKey = ["is-curator"];
  const query = () =>
    nextApiRequest(`is-curator`, "POST", { wallet: account }) as Promise<{
      isCurator: boolean;
    }>;
  const res = useQuery(cacheKey, query);
  console.log(res);

  if (res.data && !res.isLoading && !res.isError) return res.data.isCurator;
  else return false;
};
