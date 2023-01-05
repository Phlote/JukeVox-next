import { GenericSubmission } from "../types";
import { nextApiRequest } from "../utils";

export const getSubmissions = async (
  filters: Partial<GenericSubmission> = {}
): Promise<GenericSubmission[]> => {
  return nextApiRequest(`get-submissions`, "POST", {
    filters,
  }) as Promise<GenericSubmission[]>;
};

export const submit = async (submission: GenericSubmission, wallet: string, type: string) => {
  return await nextApiRequest(`submit`, "POST", { submission, wallet, type });
};
