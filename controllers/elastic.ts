import { Curation } from "../types/curations";
import { nextApiRequest } from "../utils";
// This is a nodejs client that is for reading and writing data to elastic. ELASTIC_APP_SEARCH_PRIVATE_API_KEY shouldn't be on the frontend

// Adds submission to search index;
export const indexSubmission = async (submission: Curation) => {
  const { documents } = await nextApiRequest(
    "elastic/index-documents",
    "POST",
    [submission]
  );
};
