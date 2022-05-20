import { useQuery } from "@apollo/client";
import { useWeb3React } from "@web3-react/core";
import {
  GetCuratorAdminRoleForWalletDocument,
  GetCuratorRoleForWalletDocument,
} from "../lib/graphql/generated";

// export const useIsCurator = () => {
//   const { account } = useWeb3React();
//   const apolloClient = initializeApollo();
//   const cacheKey = ["is-curator", account];
//   const query = useQuery(
//     cacheKey,
//     async () => {
//       const res = await apolloClient.query<GetCuratorRoleForWalletQuery>({
//         query: GetCuratorRoleForWalletDocument,
//         variables: { id: account },
//       });
//       return !!res?.data?.curatorRole?.isCurator;
//     },
//     {
//       refetchOnWindowFocus: false,
//       keepPreviousData: true,
//       enabled: !!account,
//     }
//   );

//   return query;
// };

export const useIsCurator = () => {
  const { account } = useWeb3React();

  const { loading, error, data } = useQuery(GetCuratorRoleForWalletDocument, {
    variables: { id: account?.toLowerCase() },
    skip: !account,
  });

  return !!data?.curatorRole?.isCurator;
};

//can add curators
export const useIsCuratorAdmin = () => {
  const { account } = useWeb3React();

  const { loading, error, data } = useQuery(
    GetCuratorAdminRoleForWalletDocument,
    {
      variables: { id: account?.toLowerCase() },
      skip: !account,
    }
  );

  return !!data?.curatorAdminRole?.isCuratorAdmin;
};
