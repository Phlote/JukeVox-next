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

export const getProfileWithFilter = async (filter: Partial<UserProfile>) => {
  const profilesQuery = await supabase.from("profiles").select().match(filter);

  if (profilesQuery.error) throw profilesQuery.error;

  if (profilesQuery.data.length === 0) return null;

  const profileMeta = profilesQuery.data[0];

  if (profileMeta.profilePic)
    //See: https://github.com/supabase/supabase/discussions/5737
    profileMeta.profilePic = `${profileMeta.profilePic}?cacheBust=${profileMeta.updateTime}`;

  // get number of cosigns

  const matchFilter = {} as Partial<Submission>;
  //TODO should rename "wallet" to "curatorWallet"
  if (filter.username) matchFilter.username = filter.username;
  else if (filter.wallet) matchFilter.curatorWallet = filter.wallet;

  const submissionsQuery = await supabase
    .from("submissions")
    .select()
    .match(matchFilter);

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
