import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";
import { curationToElasticSearchDocument } from "../../utils";
import { getSubmissionsWithFilter } from "../../utils/supabase";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { searchTerm, filters, isCurator } = request.body;

  try {
    let query = supabase.from("submissions").select();

    if (searchTerm && searchTerm.length > 0) {
      const res = await nodeElasticClient.search(
        ELASTIC_ENGINE_NAME,
        searchTerm as string,
        { filters: curationToElasticSearchDocument(filters) }
      );

      if (res.results.length === 0) response.status(200).send({ results: [] });

      const ids = res.results.map((document) =>
        parseInt(document.supabase_id.raw)
      ) as number[];

      query = query.in("id", ids);
    }

    const submissions = await getSubmissionsWithFilter(
      query,
      filters,
      isCurator
    );

    response.status(200).send(submissions);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
