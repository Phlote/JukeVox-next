import { PostgrestFilterBuilder } from "@supabase/postgrest-js";
import { cleanSubmission } from ".";
import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { supabase } from "../lib/supabase";
import { Curation } from "../types/curations";

export const getSubmissionsWithFilter = async (
  selectStatement: PostgrestFilterBuilder<any> = null,
  filters: Partial<Curation> = null,
  isCurator: boolean = false
) => {
  if (!selectStatement) selectStatement = supabase.from("submissions").select();

  if (!isCurator) selectStatement = selectStatement.not("cosigns", "is", null);

  if (filters) selectStatement = selectStatement.match(filters);

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
    (acc, curr) => acc + (curr?.cosigns?.length ?? 0),
    0
  );

  return { ...profileMeta, profilePic: publicURL, cosigns } as UserProfile;
};
