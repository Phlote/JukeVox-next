import { useQuery } from "react-query";
import { nextApiRequest } from "../utils/";
import { useMoralis } from "react-moralis";

export const useIsCurator = () => {
  const { account } = useMoralis();

  const cacheKey = ["is-curator", account];
  const query = useQuery(
    cacheKey,
    async () => {
      return nextApiRequest(`is-curator`, "POST", {
        wallet: account,
      }) as Promise<{
        isCurator: boolean;
      }>;
    },
    { refetchOnWindowFocus: false, keepPreviousData: true, enabled: !!account }
  );

  return query;
};
