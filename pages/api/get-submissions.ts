import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";
import { Curation } from "../../types/curations";
import { cleanSubmission } from "../../utils";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { filters } = request.body;

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

  const cleaned = sorted.map(cleanSubmission);

  response.status(200).json(cleaned);
}
