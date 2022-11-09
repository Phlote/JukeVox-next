import { nextApiRequest } from "../utils";

export const revalidate = async (wallet?: string, submissionID?: number) => {
  await nextApiRequest(`revalidate`, "POST", {
    wallet,
    submissionID,
  });
};
