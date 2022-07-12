import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";

const cloudFunctionName = "launchZoraAuction";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  try {
    const { submissionId, cosignerWallet } = request.body;
    let minted = false;

    const submissionsQuery = await supabase
      .from("submissions")
      .select()
      .match({ id: submissionId });

    if (!submissionsQuery.data || submissionsQuery.data.length === 0)
      throw "Invalid Submission ID";

    const { id, cosigns, curatorWallet } = submissionsQuery
      .data[0] as Submission;

    if (cosigns && cosigns?.length === 5) throw "Max 5 cosigns per submission";

    if (cosigns && cosigns?.includes(cosignerWallet))
      throw "You are not allowed to cosign a submission more than once!";

    if (curatorWallet === cosignerWallet)
      throw "You are not allowed to cosign your own submission!";

    let updatedCosigns: string[];
    if (cosigns) {
      updatedCosigns = [...cosigns, cosignerWallet];
    } else updatedCosigns = [cosignerWallet];

    // if we now have 5, mint this on Zora
    if (updatedCosigns.length === 5) {
      console.log("Sending over submission to Minting Cloud Function");
      const res = await fetch(
        `${process.env.MORALIS_SERVER_URL}/functions/${cloudFunctionName}?_ApplicationId=${process.env.MORALIS_APP_ID}`
      );
      console.log((await res.json()).result);
      minted = true;
    }

    const { data, error } = await supabase
      .from("submissions")
      .upsert({ id, cosigns: updatedCosigns });

    if (error || data?.length === 0) throw error;
    response.status(200).send({ cosigns: data[0].cosigns, minted });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
