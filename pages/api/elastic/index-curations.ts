import { NextApiRequest, NextApiResponse } from "next";
import {
  Curation,
  CurationElasticSearchDocument,
} from "../../../types/curations";
import { nodeElasticClient } from "../../../utils/elastic-app-search";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const submissions = request.body as Curation[];
  const documents = submissions.map((s) => {
    const {
      mediaType,
      artistName,
      artistWallet,
      curatorWallet,
      mediaTitle,
      mediaURI,
      marketplace,
      tags,
    } = s;
    return {
      media_type: mediaType,
      artist_name: artistName,
      artist_wallet: artistWallet,
      curator_wallet: curatorWallet,
      media_title: mediaTitle,
      media_uri: mediaURI,
      marketplace,
      tags,
    } as CurationElasticSearchDocument;
  });
  try {
    const res = await nodeElasticClient.indexDocuments(
      ELASTIC_ENGINE_NAME,
      documents
    );
    console.log(res);
    response.status(200).send({ documents: res });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
