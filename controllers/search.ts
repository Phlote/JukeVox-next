import { Submission } from "../types/curations";
import { nextApiRequest } from "../utils";

export const searchSubmissions = async (
  searchTerm: string,
  filters: Partial<Submission>,
  isCurator: boolean
): Promise<Submission[]> => {
  const results = await nextApiRequest("search", "POST", {
    searchTerm,
    filters,
    isCurator,
  });
  return results as Submission[];
};
