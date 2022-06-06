import { Submission } from "../types";
import { nextApiRequest } from "../utils";

export const searchSubmissions = async (
  searchTerm: string,
  filters: Partial<Submission>
): Promise<Submission[]> => {
  const results = await nextApiRequest("search", "POST", {
    searchTerm,
    filters,
  });
  return results as Submission[];
};
