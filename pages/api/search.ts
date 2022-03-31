import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { searchTerm, filters } = request.body;
  console.log("search term", searchTerm);
  console.log("filters", filters);

  try {
    const res = await nodeElasticClient.search(
      ELASTIC_ENGINE_NAME,
      searchTerm as string,
      { filters }
    );

    if (res.results.length === 0) response.status(200).send({ results: [] });

    const ids = res.results.map((document) =>
      parseInt(document.supabase_id.raw)
    ) as number[];

    // don't use it if we have nothing, right?

    const { data, error } = await supabase
      .from("submissions")
      .select()
      .in("id", ids);

    if (error) throw error;

    response.status(200).send({ results: data });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
