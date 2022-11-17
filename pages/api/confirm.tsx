import { ethers } from "ethers";
import { NextApiRequest, NextApiResponse } from "next/dist/shared/lib/utils";
import { supabase } from "../../lib/supabase";
import { UserNonce } from "../../types";
import { PHLOTE_SIGNATURE_REQUEST_MESSAGE } from "../../utils/constants";

// UNUSED

export default async function confirm(
  req: NextApiRequest,
  res: NextApiResponse
) {
  let authenticated = false;

  const { wallet, signature } = req.query;
  const address = wallet as string;
  const userQuery = await supabase.from("users").select().match({ address });
  const user = userQuery.data[0] as UserNonce;

  const decodedAddress = ethers.utils.verifyMessage(
    PHLOTE_SIGNATURE_REQUEST_MESSAGE + user.nonce.toString(),
    signature as string
  );
  if (address.toLowerCase() === decodedAddress.toLowerCase())
    authenticated = true;

  res.status(200).json({ authenticated });
}
