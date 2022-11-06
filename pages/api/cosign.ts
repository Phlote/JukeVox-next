import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  try {
    const { submissionID, cosignerWallet } = request.body;

    const submissionsQuery = await supabase
      .from('Curator_Submission_Table')
      .select()
      .match({ submissionID }); // Here the submissionID is made sure to be valid and corresponding to an existing submission

    if (!submissionsQuery.data || submissionsQuery.data.length === 0)
      throw "Invalid Submission ID";

    console.log(submissionsQuery);

    const { submissionID: verifiedId, cosigns, submitterWallet } = submissionsQuery
      .data[0] as Submission;

    if (cosigns && cosigns?.length === 5) throw "Max 5 cosigns per submission";

    if (cosigns && cosigns?.includes(cosignerWallet))
      throw "You are not allowed to cosign a submission more than once!";

    if (submitterWallet === cosignerWallet)
      throw "You are not allowed to cosign your own submission!";

    let updatedCosigns: string[];
    if (cosigns) {
      updatedCosigns = [...cosigns, cosignerWallet];
    } else updatedCosigns = [cosignerWallet];

    const { data, error } = await supabase
      .from('Curator_Submission_Table')
      .update({ submissionID: verifiedId, cosigns: updatedCosigns, noOfCosigns: updatedCosigns.length });

    if (error || data?.length === 0) throw error;

    response.status(200).send({ cosigns: data[0].cosigns });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
