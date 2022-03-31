import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../../lib/elastic-app-search";
import {
  Curation,
  CurationElasticSearchDocument,
} from "../../../types/curations";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const submissions = request.body as Curation[];
  const documents = submissions.map((s) => {
    const {
      id,
      mediaType,
      artistName,
      artistWallet,
      curatorWallet,
      mediaTitle,
      mediaURI,
      marketplace,
      tags,
      submissionTime,
    } = s;
    return {
      supabase_id: id,
      media_type: mediaType,
      artist_name: artistName,
      artist_wallet: artistWallet,
      curator_wallet: curatorWallet,
      media_title: mediaTitle,
      media_uri: mediaURI,
      marketplace,
      tags,
      submission_time: submissionTime,
    } as CurationElasticSearchDocument;
  });
  try {
    const res = await nodeElasticClient.indexDocuments(
      ELASTIC_ENGINE_NAME,
      documents
    );
    // Does not throw on indexing error, see: https://github.com/elastic/app-search-node
    if (res[0].errors.length > 0) throw res;

    response.status(200).send({ documents: res });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
