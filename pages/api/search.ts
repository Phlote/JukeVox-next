import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";
import { submissionToElasticSearchDocument } from "../../utils";
import { getSubmissionsWithFilter, PAGE_SIZE } from "../../utils/supabase";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { searchTerm, filters, page } = request.body;

  try {
    let query = supabase.from('submissions').select();

    if (searchTerm && searchTerm.length > 0) {
      const res = await nodeElasticClient.search(
        ELASTIC_ENGINE_NAME,
        searchTerm as string,
        { filters: submissionToElasticSearchDocument(filters) }
      );

      if (res.results.length === 0) {
        response.status(200).send({ submissions: [] });
        return;
      }

      const ids = res.results.map((document) =>
        parseInt(document.supabase_id.raw)
      ) as number[];

      query = query.in("id", ids);
    }

    const submissions = await getSubmissionsWithFilter(query, filters, page);

    response.status(200).send({
      submissions: submissions,
      nextPage: submissions.length < PAGE_SIZE ? undefined : page + 1,
    });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
