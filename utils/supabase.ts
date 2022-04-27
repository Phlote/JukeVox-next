import { PostgrestFilterBuilder } from "@supabase/postgrest-js";
import { cleanSubmission } from ".";
import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { supabase } from "../lib/supabase";
import { Submission } from "../types";

export const getSubmissionsWithFilter = async (
  selectStatement: PostgrestFilterBuilder<any> = null,
  filters: Partial<Submission> = null,
  isCurator: boolean = false
) => {
  if (!selectStatement) selectStatement = supabase.from("submissions").select();

  if (!isCurator) selectStatement = selectStatement.not("cosigns", "is", null);

  if (filters) selectStatement = selectStatement.match(filters);

  const { data, error } = await selectStatement;
  if (error) throw error;

  const sorted = data.sort((a: Submission, b: Submission) => {
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

  if (profilesQuery.data.length === 0) return null;

  const profileMeta = profilesQuery.data[0];

  if (profileMeta.profilePic)
    // TODO: the below is a bandaid, I'd like to do a more complicated solution but I think this is ok for now
    //See: https://github.com/supabase/supabase/discussions/5737
    profileMeta.profilePic =
      profileMeta.profilePic + `?cacheBust=${profileMeta.updateTime}`;

  // get number of cosigns

  const submissionsQuery = await supabase
    .from("submissions")
    .select()
    .match({ curatorWallet: wallet });

  if (submissionsQuery.error) throw submissionsQuery.error;

  const submissions = submissionsQuery.data as Submission[];
  const cosigns = submissions.reduce(
    (acc, curr) => acc + (curr?.cosigns?.length ?? 0),
    0
  );

  return {
    ...profileMeta,
    cosigns,
  } as UserProfile;
};
