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
    return results;
  } catch (e) {
    console.error(e);
  }
};
