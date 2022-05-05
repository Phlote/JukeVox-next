import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { nextApiRequest } from "../utils";
import { revalidate } from "./revalidate";

export const getProfileForWallet = async (
  wallet: string
): Promise<UserProfile> => {
  return (await nextApiRequest(
    `profile?wallet=${wallet}`
  )) as Promise<UserProfile>;
};

export const updateProfileAndRevalidate = async (
  wallet: string,
  formData: Partial<UserProfile>
): Promise<UserProfile> => {
  const profile = await (nextApiRequest(`update-profile`, "POST", {
    wallet,
    ...formData,
  }) as Promise<UserProfile>);
  if (formData.username) await revalidate(formData.username);
  return profile;
};
