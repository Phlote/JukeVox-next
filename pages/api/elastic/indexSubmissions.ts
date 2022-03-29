import { NextApiRequest, NextApiResponse } from "next";
import { ELASTIC_ENGINE_NAME } from "../../../constants";
import { nodeElasticClient } from "../../../utils/elastic-app-search";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { submissions } = request.body;

  const res = await nodeElasticClient.indexDocuments(
    ELASTIC_ENGINE_NAME,
    submissions
  );

  response.status(200).send({ documents: res });
}
