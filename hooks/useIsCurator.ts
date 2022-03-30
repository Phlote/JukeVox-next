import { useWeb3React } from "@web3-react/core";
import { useQuery } from "react-query";
import { nextApiRequest } from "../utils/";

export const useIsCurator = () => {
  const { account } = useWeb3React();

  const cacheKey = ["is-curator", account];
  const query = useQuery(
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

  return query.data && query.data.isCurator;
};
