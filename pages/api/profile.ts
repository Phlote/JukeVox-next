import { NextApiRequest, NextApiResponse } from "next";
import { UserProfile } from "../../components/Forms/ProfileSettingsForm";
import { supabase } from "../../lib/supabase";
import { Curation } from "../../types/curations";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { wallet } = request.query;

  // get profile metadata
  // get profile pic

  try {
    const profilesQuery = await supabase
      .from("profiles")
      .select()
      .match({ wallet });

    if (profilesQuery.error) throw profilesQuery.error;

    const profileMeta = profilesQuery.data[0];

    const { publicURL, error } = await supabase.storage
      .from("profile-pics")
      .getPublicUrl(`${wallet}/profile`);

    if (error) throw error;

    // get number of cosigns

    const submissionsQuery = await supabase
      .from("submissions")
      .select()
      .match({ curatorWallet: wallet });

    if (submissionsQuery.error) throw submissionsQuery.error;

    const submissions = submissionsQuery.data as Curation[];
    const cosigns = submissions.reduce(
      (acc, curr) => acc + curr.cosigns.length,
      0
    );

    response
      .status(200)
      .send({ ...profileMeta, profilePic: publicURL, cosigns } as UserProfile);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
