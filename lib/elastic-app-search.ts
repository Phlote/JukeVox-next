import AppSearchClient from "@elastic/app-search-node";

const { ELASTIC_APP_SEARCH_API_ENDPOINT, ELASTIC_APP_SEARCH_PRIVATE_API_KEY } =
  process.env;

const baseUrlFn = () => ELASTIC_APP_SEARCH_API_ENDPOINT;

export const nodeElasticClient = new AppSearchClient(
  undefined,
  ELASTIC_APP_SEARCH_PRIVATE_API_KEY,
  baseUrlFn
);
