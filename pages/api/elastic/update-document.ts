import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../../lib/elastic-app-search";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { updates, documentId } = request.body;
  try {
    const res = await nodeElasticClient.updateDocuments(ELASTIC_ENGINE_NAME, [
      {
        id: documentId,
        ...updates,
      },
    ]);

    response.status(200).send({ res });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
