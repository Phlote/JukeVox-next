import { nextApiRequest } from "../utils";

export const revalidate = async (username: string) => {
  await nextApiRequest(`revalidate`, "POST", {
    username,
  });
};
