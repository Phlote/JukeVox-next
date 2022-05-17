import { Submission } from "../types";
import { nextApiRequest } from "../utils";

export const getSubmissions = async (
  filters: Partial<Submission> = {}
): Promise<Submission[]> => {
  return nextApiRequest(`get-submissions`, "POST", {
    filters,
  }) as Promise<Submission[]>;
};

export const submit = async (submission: Submission, wallet: string) => {
  return await nextApiRequest(`submit`, "POST", { submission, wallet });
};

export const uploadToIPFS = async (submission: Submission, wallet: string) => {
  return await nextApiRequest("upload-ipfs", "POST", {
    submission,
    wallet,
  });
};
