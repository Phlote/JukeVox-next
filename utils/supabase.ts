import { PostgrestFilterBuilder } from "@supabase/postgrest-js";
import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { supabase } from "../lib/supabase";
import { Submission } from "../types";

export const getSubmissionsWithFilter = async (
  selectStatement: PostgrestFilterBuilder<any> = null,
  filters: Partial<Submission> = null,
  page: number = 1
) => {
  const { from, to } = getPagination(page);
  if (!selectStatement) selectStatement = supabase.from("submissions").select();

  if (filters) selectStatement = selectStatement.match(filters);

  selectStatement.order("submissionTime", { ascending: false }).range(from, to);

  const { data, error } = await selectStatement;
  if (error) throw error;

  //TODO: is this too slow?
  return data;
  // return data.map(cleanSubmission);
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
    //See: https://github.com/supabase/supabase/discussions/5737
    profileMeta.profilePic = `${profileMeta.profilePic}?cacheBust=${profileMeta.updateTime}`;

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

export const PAGE_SIZE = 50;

export const getPagination = (page, size = PAGE_SIZE) => {
  const limit = size ? +size : 3;
  const from = page ? page * limit : 0;
  const to = page ? from + size - 1 : size - 1;

  return { from, to };
};
