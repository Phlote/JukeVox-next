import { useWeb3React } from "@web3-react/core";
import { useQuery } from "react-query";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetCuratorAdminRoleForWalletDocument,
  GetCuratorAdminRoleForWalletQuery,
  GetCuratorRoleForWalletDocument,
  GetCuratorRoleForWalletQuery,
} from "../lib/graphql/generated";

export const useIsCurator = () => {
  const { account } = useWeb3React();
  const apolloClient = initializeApollo();
  const cacheKey = ["is-curator", account];
  const query = useQuery(
    cacheKey,
    async () => {
      const res = await apolloClient.query<GetCuratorRoleForWalletQuery>({
        query: GetCuratorRoleForWalletDocument,
        variables: { id: account },
      });
      return !!res?.data?.curatorRole?.isCurator;
    },
    {
      refetchOnWindowFocus: false,
      keepPreviousData: true,
      enabled: !!account,
    }
  );

  return query;
};

//can add curators
export const useIsCuratorAdmin = () => {
  const { account } = useWeb3React();
  const apolloClient = initializeApollo();
  const cacheKey = ["is-curator-admin", account];
  const query = useQuery(
    cacheKey,
    async () => {
      const res = await apolloClient.query<GetCuratorAdminRoleForWalletQuery>({
        query: GetCuratorAdminRoleForWalletDocument,
        variables: { id: account },
      });
      return !!res?.data?.curatorAdminRole?.isCuratorAdmin;
    },
    {
      refetchOnWindowFocus: false,
      keepPreviousData: true,
      enabled: !!account,
    }
  );

  return query;
};
