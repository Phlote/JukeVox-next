import { NextApiRequest, NextApiResponse } from "next";
import { UserProfile } from "../../components/Forms/ProfileSettingsForm";
import { updateProfile } from "../../utils/supabase";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const profile = await updateProfile(request.body as UserProfile);
  response.status(200).send(profile);
}
