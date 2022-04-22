import { Curation } from "../types/curations";
import { nextApiRequest } from "../utils";

export const searchSubmissions = async (
  searchTerm: string,
  filters: Partial<Curation>,
  isCurator: boolean
): Promise<Curation[]> => {
  const results = await nextApiRequest("search", "POST", {
    searchTerm,
    filters,
    isCurator,
  });
  return results as Curation[];
};
