import { NextApiRequest, NextApiResponse } from "next";
import { pinFile } from "../../../utils/moralis";

export const config = {
  api: {
    bodyParser: {
      sizeLimit: "5mb",
    },
  },
};

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { b64File, name } = request.body;

  const res = await pinFile(b64File as string, name as string);
  response.status(200).send(res);
}
