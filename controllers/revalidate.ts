import { nextApiRequest } from "../utils";

export const revalidate = async (username?: string, submissionId?: number) => {
  await nextApiRequest(`revalidate`, "POST", {
    username,
    submissionId,
  });
};
