import { Submission } from "../lib/graphql/generated";
import { nextApiRequest } from "../utils";

export const uploadToIPFS = async (submission: Submission, wallet: string) => {
  return await nextApiRequest("upload-ipfs", "POST", {
    submission,
    wallet,
  });
};
