import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";
import { ArtistSubmission, CuratorSubmission } from "../../types";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  try {
    const { submissionID, cosignerWallet } = request.body;

    const submissionsQuery = await supabase
      .from('submissions')
      .select()
      .match({ submissionID }); // Here the submissionID is made sure to be valid and corresponding to an existing submission

    if (!submissionsQuery.data || submissionsQuery.data.length === 0)
      throw "Invalid Submission ID";

    console.log(submissionsQuery);

    const { submissionID: verifiedId, cosigns, submitterWallet, isArtist } = submissionsQuery
      .data[0] as ArtistSubmission | CuratorSubmission;

    if (cosigns && cosigns?.length === 5) throw "Max 5 cosigns per submission";

    if (cosigns && cosigns?.includes(cosignerWallet))
      throw "You are not allowed to cosign a submission more than once!";

    if (submitterWallet === cosignerWallet)
      throw "You are not allowed to cosign your own submission!";

    let updatedCosigns: string[];
    if (cosigns) {
      updatedCosigns = [...cosigns, cosignerWallet];
    } else updatedCosigns = [cosignerWallet];

    let tableName = 'Curator_Submission_Table';
    if (isArtist) tableName = 'Artist_Submission_Table';

    const { data, error } = await supabase
      .from(tableName)
      .update({ submissionID: verifiedId, cosigns: updatedCosigns, noOfCosigns: updatedCosigns.length });

    if (error || data?.length === 0) throw error;

    response.status(200).send({ cosigns: data[0].cosigns });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
