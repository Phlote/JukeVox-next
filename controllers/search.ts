import { GenericSubmission } from "../types";
import { nextApiRequest } from "../utils";

interface SearchResults {
  submissions: GenericSubmission[];
  nextPage: number;
}

export const searchSubmissions = async (
  searchTerm: string,
  filters: Partial<GenericSubmission>,
  page: number
): Promise<SearchResults> => {
  const results = await nextApiRequest("search", "POST", {
    searchTerm,
    filters,
    page,
  });

  return results as SearchResults;
};
