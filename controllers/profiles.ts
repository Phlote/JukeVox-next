import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { nextApiRequest } from "../utils";

export const getProfile = async (wallet: string): Promise<UserProfile> => {
  let result = (await nextApiRequest(
    `profile?wallet=${wallet}`
  )) as Promise<UserProfile>;
  console.log(wallet);
  console.log(result);
  return result;
};
