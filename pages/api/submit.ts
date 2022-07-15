import cuid from "cuid";
import Moralis from "moralis/node";
import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";
import { submissionToElasticSearchDocument } from "../../utils";

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

// See here: https://gateway.pinata.cloud/ipfs/Qmb8Jmabe5agSBxjScYQ9cyZvbBopMRUvnFg3SpJTA4jp6
const defaultSubmissionImage =
  "ipfs://Qmb8Jmabe5agSBxjScYQ9cyZvbBopMRUvnFg3SpJTA4jp6";

const storeSubmissionOnIPFS = async (
  submission: Submission,
  imageUrl = defaultSubmissionImage
) => {
  const serverUrl = process.env.MORALIS_SERVER_URL;
  const appId = process.env.MORALIS_APP_ID;
  const masterKey = process.env.MORALIS_MASTER_KEY;

  await Moralis.start({ serverUrl, appId, masterKey });

  const { artistName, artistWallet, curatorWallet, mediaTitle, mediaURI } =
    submission;

  const nftMetadata = {
    title: "Phlote Submissions NFT",
    description: "Thanks for submitting to Phlote",
    image: imageUrl,
    properties: {
      artistName,
      artistWallet,
      curatorWallet,
      mediaTitle,
      mediaURI,
    },
  };

  const metadataFile = new Moralis.File("metadata.json", {
    base64: Buffer.from(JSON.stringify(nftMetadata)).toString("base64"),
  });
  await metadataFile.saveIPFS({ useMasterKey: true });
  return metadataFile.url();
};
