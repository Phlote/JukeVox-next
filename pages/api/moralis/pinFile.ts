import { NextApiRequest, NextApiResponse } from "next";
import { pinFile } from "../../../utils/moralis";
import * as fs from "fs";
import fetch from "node-fetch";

export const config = {
  api: {
    bodyParser: {
      sizeLimit: "100mb",
    },
  },
};

const toBase64 = (file: ArrayBuffer) => {
    return Buffer.from(file).toString('base64');
  };

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { url, name } = request.body;

  const fileResponse = await fetch(url);
  const fileResult = await fileResponse.arrayBuffer();

  let b64File = toBase64(fileResult);

  try {
    const res = await pinFile(b64File as string, name as string);
    response.status(200).send(res);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
