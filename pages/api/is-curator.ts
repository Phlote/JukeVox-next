import { NextApiRequest, NextApiResponse } from "next";
import { PhloteVoteAddress } from "../../solidity/utils/PhloteVote";

interface PolygonScanTokenBalanceResponse {
  status: string;
  message: string;
  result: string;
}

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { wallet } = request.body;

  const resp = await fetch(
    `https://api-testnet.polygonscan.com/api?module=account&action=tokenbalance&contractaddress=${PhloteVoteAddress}&address=${wallet}&tag=latest&apikey=${process.env.POLYGONSCAN_API_KEY}`
  );

  const result = (await resp.json()) as PolygonScanTokenBalanceResponse;
  const isCurator = parseInt(result.result) > 0;
  response.status(200).json({
    isCurator,
  });
}
