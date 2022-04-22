import { NextApiRequest, NextApiResponse } from "next";
import { getSubmissionsWithFilter } from "../../utils/supabase";
import { walletIsCurator } from "../../utils/web3";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { filters, wallet } = request.body;

  const submissions = await getSubmissionsWithFilter(null, filters, isCurator);
  console.log("the submissions");

  response.status(200).json(submissions);
}
