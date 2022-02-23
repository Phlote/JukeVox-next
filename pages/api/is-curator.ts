import { parse } from "@ethersproject/transactions";
import { NextApiRequest, NextApiResponse } from "next";

export const TEST_PHOTE_TOKEN_ADDRESS =
  "0x31DA0475d29a452DA24Eb2ed0d41AD53E576b780";

export const PHOTE_VOTE_TOKEN_ADDRESS =
  "0x31DA0475d29a452DA24Eb2ed0d41AD53E576b780";

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
    `https://api.polygonscan.com/api?module=account&action=tokenbalance&contractaddress=${TEST_PHOTE_TOKEN_ADDRESS}&address=${wallet}&tag=latest&apikey=${process.env.POLYGONSCAN_API_KEY}`
  );

  const { result } = (await resp.json()) as PolygonScanTokenBalanceResponse;

  console.log(result);

  const isCurator = parseInt(result) > 0;

  response.status(200).json({
    isCurator,
  });
}
