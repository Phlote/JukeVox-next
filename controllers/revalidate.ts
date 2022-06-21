import { nextApiRequest } from "../utils";

export const revalidate = async (
  username?: string,
  submissionAddress?: string
) => {
  await nextApiRequest(`revalidate`, "POST", {
    username,
    submissionAddress,
  });
};
