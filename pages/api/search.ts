import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";
import { curationToElasticSearchDocument } from "../../utils";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { searchTerm, filters } = request.body;

  try {
    let query = supabase.from("submissions").select();

    console.log("searchTerm: ", searchTerm);
    console.log("filters: ", filters);

    if (filters) {
      query = query.match(filters);
    }

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

    const { data, error } = await query;
    const searchResults = data.sort((a, b) => {
      return new Date(b.date).getTime() - new Date(a.date).getTime();
    });
    console.log("search results: ", searchResults);

    if (error) throw error;

    response.status(200).send({ results: searchResults });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
