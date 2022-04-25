import { Submission } from "../types/curations";
import { nextApiRequest } from "../utils";

export const getSubmissions = async (
  filters: Partial<Submission> = {}
): Promise<Submission[]> => {
  return nextApiRequest(`get-submissions`, "POST", {
    filters,
  }) as Promise<Submission[]>;
};

export const submit = async (submission: Submission, wallet: string) => {
  await nextApiRequest(`submit`, "POST", { submission, wallet });
};
