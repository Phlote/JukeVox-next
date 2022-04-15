import { cleanSubmission } from ".";
import { supabase } from "../lib/supabase";
import { Curation } from "../types/curations";

export const getAllSubmissionsWithFilter = async (
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
