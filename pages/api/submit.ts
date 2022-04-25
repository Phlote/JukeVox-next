import pinataSDK from "@pinata/sdk";
import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";
import { submissionToElasticSearchDocument } from "../../utils";

const { ELASTIC_ENGINE_NAME, PINATA_API_KEY, PINATA_SECRET_API_KEY } =
  process.env;

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

    // could store in IPFS here

    const submissionsInsert = await supabase
      .from("submissions")
      .insert([submissionWithSubmitterInfo]);

    if (submissionsInsert.error) throw submissionsInsert.error;

    await indexSubmission(submissionsInsert.data[0] as Submission);

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

const storeSubmissionOnIPFS = async (submission: Submission) => {
  const pinata = pinataSDK(PINATA_API_KEY, PINATA_SECRET_API_KEY);

  const {
    mediaType,
    artistName,
    artistWallet,
    curatorWallet,
    mediaTitle,
    mediaURI,
    marketplace,
    tags,
  } = submission;

  const erc1155Metadata = {
    title: "Phlote Curation NFT",
    description: "Thanks for curating on Phlote",
    image: "url",
    properties: {
      mediaType,
      artistName,
      artistWallet,
      curatorWallet,
      mediaTitle,
      mediaURI,
      marketplace,
      tags: {
        name: "tags",
        value: tags,
      },
    },
  };
  const pin = await pinata.pinJSONToIPFS(erc1155Metadata);
  console.log("Pinned here: ", pin);
};
