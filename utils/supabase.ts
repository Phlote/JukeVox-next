import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetSubmissionsDocument,
  GetSubmissionsQuery,
} from "../lib/graphql/generated";
import { supabase } from "../lib/supabase";

export const getProfileForWallet = async (wallet: string) => {
  const profilesQuery = await supabase
    .from("profiles")
    .select()
    .match({ wallet });

  if (profilesQuery.error) throw profilesQuery.error;

  if (profilesQuery.data.length === 0) return null;

  const profileMeta = profilesQuery.data[0];

  if (profileMeta.profilePic)
    //See: https://github.com/supabase/supabase/discussions/5737
    profileMeta.profilePic = `${profileMeta.profilePic}?cacheBust=${profileMeta.updateTime}`;

  // get number of cosigns
  const apolloClient = initializeApollo();
  const res = await apolloClient.query<GetSubmissionsQuery>({
    query: GetSubmissionsDocument,
    variables: { filter: { submitterWallet: wallet } },
  });

  const cosigns = res.data.submissions.reduce(
    (acc, curr) => acc + (curr?.cosigns?.length ?? 0),
    0
  );

  return {
    ...profileMeta,
    cosigns,
  } as UserProfile;
};

export const PAGE_SIZE = 50;

export const getPagination = (page, size = PAGE_SIZE) => {
  const limit = size ? +size : 3;
  const from = page ? page * limit : 0;
  const to = page ? from + size - 1 : size - 1;

  return { from, to };
};
