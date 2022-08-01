import { NextApiRequest, NextApiResponse } from "next";
import { pinFile } from "../../../utils/moralis";

export const config = {
  api: {
    bodyParser: {
      sizeLimit: "100mb",
    },
  },
};

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { url } = request.body;

  const fileResponse = await fetch(url);
  const fileResult = fileResponse.blob();

  try {
    const res = await pinFile(fileResult as string, name as string);
    response.status(200).send(res);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
