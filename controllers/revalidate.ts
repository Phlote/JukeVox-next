import { nextApiRequest } from "../utils";

export const revalidate = async (username?: string, submissionID?: number) => {
  await nextApiRequest(`revalidate`, "POST", {
    username,
    submissionID,
  });
};
