import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { nextApiRequest } from "../utils";

export const getProfile = async (wallet: string): Promise<UserProfile> => {
  try {
    return nextApiRequest(`profile?wallet=${wallet}`) as Promise<UserProfile>;
  } catch (e) {
    console.error(e);
  }
};
