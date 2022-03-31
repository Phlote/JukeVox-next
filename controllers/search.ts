import { cleanSubmission } from "../hooks/useSubmissions";
import { Curation } from "../types/curations";
import { nextApiRequest } from "../utils";

export const searchSubmissions = async (
  searchTerm: string,
  filters: Partial<Curation>
): Promise<Curation[]> => {
  try {
    const { results } = await nextApiRequest("search", "POST", {
      searchTerm,
      filters,
    });
    return results.map(cleanSubmission);
  } catch (e) {
    console.error(e);
  }
};
