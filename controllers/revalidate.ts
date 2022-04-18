import { nextApiRequest } from "../utils";

export const revalidateArchive = async () => {
  await nextApiRequest(`revalidate`, "POST", { path: "/archive" });
};

export const revalidateProfile = async (username: string) => {
  await nextApiRequest(`revalidate`, "POST", {
    path: `/profile/${username}`,
  });
};
