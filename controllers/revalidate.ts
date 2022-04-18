import { nextApiRequest } from "../utils";

export const revalidateArchive = async () => {
  // when a user submits something
  // revalidate the archive page
  // if they have a profile, revalidate their profile

  nextApiRequest(`revalidate`, "POST", { path: "/archive" });
};

export const revalidateProfile = async (username: string) => {
  // when a user submits something
  // revalidate the archive page
  // if they have a profile, revalidate their profile
  nextApiRequest(`revalidate`, "POST", { path: `/profile/${username}` });
};
