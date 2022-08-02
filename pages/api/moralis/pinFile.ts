import { NextApiRequest, NextApiResponse } from "next";
import { pinFile } from "../../../utils/moralis";

export const config = {
  api: {
    bodyParser: {
      sizeLimit: "100mb",
    },
  },
};

const toBase64 = (file: Blob) =>
  new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = (error) => reject(error);
  });

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { url, name } = request.body;

  const fileResponse = await fetch(url);
  const fileResult = await fileResponse.blob();
  console.log(fileResult);

  let b64File = await toBase64(fileResult);

  try {
    const res = await pinFile(b64File as string, name as string);
    response.status(200).send(res);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
