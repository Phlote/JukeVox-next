import { Curation } from "../types/curations";
import { nextApiRequest } from "../utils";

export const getSubmissions = async (
  filters: Partial<Curation>
): Promise<Curation[]> => {
  return (await nextApiRequest(
    `get-submissions`,
    "POST",
    filters
  )) as Curation[];
};
