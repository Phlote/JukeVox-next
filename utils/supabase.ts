import { PostgrestFilterBuilder } from "@supabase/postgrest-js";
import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { supabase } from "../lib/supabase";
import { GenericSubmission } from "../types";

export const getSubmissionsWithFilter = async (
  selectStatement: PostgrestFilterBuilder<any> = null,
  filters: Partial<GenericSubmission> = null,
  page?: number
) => {
  if (!selectStatement) selectStatement = supabase.from('submissions').select();

  if (filters) {
    if (typeof filters.submitterWallet !== 'undefined') {
      selectStatement = selectStatement.ilike('submitterWallet', filters.submitterWallet.toLowerCase()); // Support old uppercase implementation
      // TODO: Make this more general, if this function is used with a submitterWallet and other filters the other filters would be ignored
    } else {
      selectStatement = selectStatement.match(filters);
    }
  }

  if (page !== undefined) {
    const { from, to } = getPagination(page);
    selectStatement = selectStatement.range(from, to);
  }

  selectStatement = selectStatement.order("submissionTime", {
    ascending: false,
  });

  const { data, error } = await selectStatement;
  if (error) throw error;

  return data;
};

export const getSubmissionById = async (id: number) => {
  return supabase.from('submissions').select().match({ id });
}

export const getProfileForWallet = async (wallet: string) => {
  wallet = wallet.toLowerCase();  // Support old uppercase implementation
  const profilesQuery = await supabase
    .from('Users_Table')
    .select()
    .ilike('wallet', wallet);

  if (profilesQuery.error) throw profilesQuery.error;

  if (profilesQuery.data.length === 0) return null;

  const profileMeta = profilesQuery.data[0];

  if (profileMeta.profilePic)
    //See: https://github.com/supabase/supabase/discussions/5737
    profileMeta.profilePic = `${profileMeta.profilePic}?cacheBust=${profileMeta.updateTime}`;

  // get number of cosigns received

  const submissionsQuery = await supabase
    .from('submissions')
    .select()
    .ilike('submitterWallet', wallet); // ilike is case-insensitive

  if (submissionsQuery.error) throw submissionsQuery.error;

  const submissions = submissionsQuery.data as GenericSubmission[];
  const cosignsReceived = submissions.reduce(
    (acc, curr) => acc + (curr?.cosigns?.length ?? 0),
    0
  );

  // get number of cosigns given

  const submissionsQueryAll = await supabase.from('submissions').select();

  const cosignsGiven = submissionsQueryAll.data
    .flatMap((submission: GenericSubmission) => submission.cosigns)
    .filter((c) => !!c)
    .reduce((acc, c) => (c.toLowerCase() === wallet ? acc + 1 : acc), 0);

  return {
    ...profileMeta,
    cosignsReceived,
    cosignsGiven,
  } as UserProfile;
};

export const PAGE_SIZE = 50;

export const getPagination = (page, size = PAGE_SIZE) => {
  const limit = size ? +size : 3;
  const from = page ? page * limit : 0;
  const to = page ? from + size - 1 : size - 1;

  return { from, to };
};
