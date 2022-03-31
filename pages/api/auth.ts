import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";

export default async function auth(req: NextApiRequest, res: NextApiResponse) {
  const { address } = req.query;
  const user = {
    address: address as string,
    nonce: Math.floor(Math.random() * 10000000),
  };
  const upsertRes = await supabase
    .from("users")
    .upsert(user, { onConflict: "address" });
  if (upsertRes.error) {
    res.status(500);
  }
  res.status(200).json(user);
}
