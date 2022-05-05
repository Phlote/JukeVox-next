import { NextApiRequest, NextApiResponse } from "next";
import { getProfileWithFilter } from "../../utils/supabase";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { wallet } = request.query;

  const profile = await getProfileWithFilter({ wallet: wallet as string });
  response.status(200).send(profile);
}
