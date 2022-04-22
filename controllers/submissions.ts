import { Curation } from "../types/curations";
import { nextApiRequest } from "../utils";

export const getSubmissions = async (
  filters: Partial<Curation> = {},
  wallet: string = null
): Promise<Curation[]> => {
  return nextApiRequest(`get-submissions`, "POST", {
    filters,
    wallet,
  }) as Promise<Curation[]>;
};

export const submit = async (submission: Curation, wallet: string) => {
  await nextApiRequest(`submit`, "POST", { submission, wallet });
};
