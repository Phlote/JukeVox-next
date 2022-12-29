import { nextApiRequest } from "../utils";

export const revalidate = async (wallet?: string, submissionID?: string) => {
  await nextApiRequest(`revalidate`, "POST", {
    wallet,
    submissionID,
  });
};
