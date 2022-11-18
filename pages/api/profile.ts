import { NextApiRequest, NextApiResponse } from "next";
import { getProfileForWallet } from "../../utils/supabase";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { wallet } = request.query;

  const profile = await getProfileForWallet(wallet as string);
  console.log(profile);
  response.status(200).send(profile);
}
