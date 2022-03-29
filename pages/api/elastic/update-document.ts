import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../../utils/elastic-app-search";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { editionId, documentId } = request.body;
  try {
    const res = await nodeElasticClient.updateDocuments(ELASTIC_ENGINE_NAME, [
      {
        id: documentId,
        editionId: editionId,
      },
    ]);

    response.status(200).send({ res });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
