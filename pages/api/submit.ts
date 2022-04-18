import pinataSDK from "@pinata/sdk";
import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../../lib/elastic-app-search";
import { Curation } from "../../../types/curations";
import { curationToElasticSearchDocument } from "../../../utils";
import { supabase } from "../../lib/supabase";

const { ELASTIC_ENGINE_NAME, PINATA_API_KEY, PINATA_SECRET_API_KEY } =
  process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { submission, wallet } = request.body;

  try {
    const profileQuery = await supabase
      .from("profiles")
      .select()
      .match({ wallet });

    const { username } = profileQuery.data[0];

    const submissionWithSubmitterInfo = {
      curatorWallet: wallet,
      username,
      ...submission,
    };

    // could store in IPFS here

    const submissionsInsert = await supabase
      .from("submissions")
      .insert([submissionWithSubmitterInfo]);

    if (submissionsInsert.error) throw submissionsInsert.error;

    await indexSubmission(submissionsInsert.data[0] as Curation);

    response.status(200);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}

const indexSubmission = async (submission: Curation) => {
  const document = curationToElasticSearchDocument(submission);
  const res = await nodeElasticClient.indexDocuments(ELASTIC_ENGINE_NAME, [
    document,
  ]);
  // Does not throw on indexing error, see: https://github.com/elastic/app-search-node
  if (res[0].errors.length > 0) throw res;
};

const storeSubmissionOnIPFS = async (submission: Curation) => {
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
