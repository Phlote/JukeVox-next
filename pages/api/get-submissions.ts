import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";
import { Curation } from "../../types/curations";

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

  const cleaned = data.map((s) => cleanSubmission(s));
  const reversed = cleaned.reverse();

  response.status(200).json(data);
}

export const cleanSubmission = (submission: Curation) => {
  const cleaned = { ...submission };
  if (submission.mediaURI.includes("opensea")) {
    cleaned.marketplace = "OpenSea";
  }
  if (submission.mediaURI.includes("catalog")) {
    cleaned.marketplace = "Catalog";
  }
  if (submission.mediaURI.includes("zora")) {
    cleaned.marketplace = "Zora";
  }
  if (submission.mediaURI.includes("foundation")) {
    cleaned.marketplace = "Foundation";
  }
  if (submission.mediaURI.includes("spotify")) {
    cleaned.marketplace = "Spotify";
  }
  if (submission.mediaURI.includes("soundcloud")) {
    cleaned.marketplace = "Soundcloud";
  }
  if (submission.mediaURI.includes("youtu")) {
    cleaned.marketplace = "Youtube";
  }

  return cleaned;
};
