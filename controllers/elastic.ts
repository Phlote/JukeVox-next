import AppSearchClient from "@elastic/app-search-node";
import { Curation } from "../types/curations";
import { nextApiRequest } from "../utils";
// This is a nodejs client that is for reading and writing data to elastic. ELASTIC_APP_SEARCH_PRIVATE_API_KEY shouldn't be on the frontend

const { ELASTIC_APP_SEARCH_API_ENDPOINT, ELASTIC_APP_SEARCH_PRIVATE_API_KEY } =
  process.env;

const baseUrlFn = () => ELASTIC_APP_SEARCH_API_ENDPOINT;

export const nodeElasticClient = new AppSearchClient(
  undefined,
  ELASTIC_APP_SEARCH_PRIVATE_API_KEY,
  baseUrlFn
);

// Adds submission to search index;
export const indexSubmission = async (submission: Curation) => {
  const { documents } = await nextApiRequest(
    "elastic/index-documents",
    "POST",
    [submission]
  );
};
