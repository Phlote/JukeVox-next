import { Submission } from "../types";
import { nextApiRequest } from "../utils";

// Adds submission to search index;
export const indexSubmission = async (submission: Submission) => {
  const { documents } = await nextApiRequest(
    "elastic/index-documents",
    "POST",
    [submission]
  );
};
