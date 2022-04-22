import { NextApiRequest, NextApiResponse } from "next";
import { walletIsCurator } from "../../utils/web3";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { wallet } = request.body;

  const isCurator = await walletIsCurator(wallet);

  response.status(200).json({
    isCurator,
  });
}
