import cuid from "cuid";
import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";
import { submissionToElasticSearchDocument } from "../../utils";
import { storeSubmissionOnIPFS } from "../../utils/moralis";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { submission, wallet } = request.body;

  try {
    const submissionWithSubmitterInfo = {
      curatorWallet: wallet,
      ...submission,
    };

    const profileQuery = await supabase
      .from("profiles")
      .select()
      .match({ wallet });

    if (profileQuery.data.length > 0) {
      const { username } = profileQuery.data[0];
      submissionWithSubmitterInfo.username = username;
    }

    const uri = await storeSubmissionOnIPFS(submissionWithSubmitterInfo);
    console.log("uri: ", uri);
    submissionWithSubmitterInfo.nftMetadata = uri;

    const submissionsInsert = await supabase
      .from("submissions")
      .insert([submissionWithSubmitterInfo]);

    if (submissionsInsert.error) throw submissionsInsert.error;

    const submissionRes = submissionsInsert.data[0] as Submission;

    await supabase.from("comments").insert([
      {
        threadId: submissionRes.id,
        slug: `submission-root-${cuid.slug()}`,
        authorId: submissionRes.curatorWallet,
        isApproved: true,
      },
    ]);

    await indexSubmission(submissionRes);

    response.status(200).send(submissionWithSubmitterInfo);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}

const indexSubmission = async (submission: Submission) => {
  const document = submissionToElasticSearchDocument(submission);
  const res = await nodeElasticClient.indexDocuments(ELASTIC_ENGINE_NAME, [
    document,
  ]);
  // Does not throw on indexing error, see: https://github.com/elastic/app-search-node
  if (res[0].errors.length > 0) throw res;
};
