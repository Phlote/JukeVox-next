import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../../lib/elastic-app-search";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { searchTerm, filters } = request.body;

  try {
    const res = await nodeElasticClient.search(
      ELASTIC_ENGINE_NAME,
      searchTerm as string,
      { filters }
    );

    const curations = res.results.map((result) => {
      const {
        media_type,
        artist_name,
        artist_wallet,
        curator_wallet,
        media_title,
        media_uri,
        marketplace,
        tags,
        submission_time,
      } = result;
      return {
        mediaType: media_type.raw,
        artistName: artist_name.raw,
        artistWallet: artist_wallet?.raw,
        curatorWallet: curator_wallet.raw,
        mediaTitle: media_title.raw,
        mediaURI: media_uri.raw,
        marketplace: marketplace.raw,
        tags,
        submissionTime: submission_time.raw,
      };
    });
    console.log(curations);

    response.status(200).send({ results: curations });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
