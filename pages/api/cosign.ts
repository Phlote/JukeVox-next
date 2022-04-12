import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";
import { Curation } from "../../types/curations";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  try {
    const { submissionId, cosignerWallet } = request.body;

    const submissionsQuery = await supabase
      .from("submissions")
      .select()
      .match({ id: submissionId });

    if (!submissionsQuery.data || submissionsQuery.data.length === 0)
      throw "Invalid Submission ID";

    const { id, cosigns, curatorWallet } = submissionsQuery.data[0] as Curation;

    if (cosigns.length === 5) throw "Max 5 cosigns per submission";

    if (curatorWallet === cosignerWallet)
      throw "You are not allowed to cosign your own submission!";

    if (cosigns.includes(cosignerWallet))
      throw "You are not allowed to cosign a submission more than once!";

    const { data, error } = await supabase
      .from("submissions")
      .upsert({ id, cosigns: [...cosigns, cosignerWallet] });

    if (error || data?.length === 0) throw error;

    response.status(200).send({ cosigns: data[0].cosigns });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
