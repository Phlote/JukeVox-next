import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { nextApiRequest } from "../utils";

export const getProfileForWallet = async (
  wallet: string
): Promise<UserProfile> => {
  return (await nextApiRequest(
    `profile?wallet=${wallet}`
  )) as Promise<UserProfile>;
};
