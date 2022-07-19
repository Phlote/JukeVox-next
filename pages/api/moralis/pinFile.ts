import { NextApiRequest, NextApiResponse } from "next";
import { pinFile } from "../../../utils/moralis";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { b64File, name } = request.body;

  const ipfs = await pinFile(b64File as string, name as string);
  response.status(200).send(ipfs);
}
