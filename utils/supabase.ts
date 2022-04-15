import { cleanSubmission } from ".";
import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { supabase } from "../lib/supabase";
import { Curation } from "../types/curations";

export const getSubmissionsWithFilter = async (
  filters: Partial<Curation> = {}
) => {
  let selectStatement = supabase.from("submissions").select();

  for (const key in filters as Curation) {
    selectStatement = selectStatement.eq(key, filters[key]);
  }

  const { data, error } = await selectStatement;
  if (error) throw error;

  const sorted = data.sort((a: Curation, b: Curation) => {
    return (
      new Date(b.submissionTime).getTime() -
      new Date(a.submissionTime).getTime()
    );
  });

  return sorted.map(cleanSubmission);
};

export const getProfileForWallet = async (wallet: string) => {
  const profilesQuery = await supabase
    .from("profiles")
    .select()
    .match({ wallet });

  if (profilesQuery.error) throw profilesQuery.error;

  const profileMeta = profilesQuery.data[0];

  const { publicURL, error } = supabase.storage
    .from("profile-pics")
    .getPublicUrl(`${wallet}/profile`);

  if (error) throw error;

  // get number of cosigns

  const submissionsQuery = await supabase
    .from("submissions")
    .select()
    .match({ curatorWallet: wallet });

  if (submissionsQuery.error) throw submissionsQuery.error;

  const submissions = submissionsQuery.data as Curation[];
  const cosigns = submissions.reduce(
    (acc, curr) => acc + curr.cosigns.length,
    0
  );

  return { ...profileMeta, profilePic: publicURL, cosigns } as UserProfile;
};
