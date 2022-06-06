import { Submission } from "../types";
import { nextApiRequest } from "../utils";

interface SearchResults {
  submissions: Submission[];
  nextPage: number;
}

export const searchSubmissions = async (
  searchTerm: string,
  filters: Partial<Submission>,
  page: number
): Promise<SearchResults> => {
  const results = await nextApiRequest("search", "POST", {
    searchTerm,
    filters,
    page,
  });

  return results as SearchResults;
};
