import { nextApiRequest } from "../utils";

export const revalidate = async (username: string = undefined) => {
  // when a user submits something
  // revalidate the archive page
  // if they have a profile, revalidate their profile

  nextApiRequest(`revalidate`, "POST", { page: "/archive" });
  if (username)
    nextApiRequest(`revalidate`, "POST", { page: `/profile/${username}` });
};
