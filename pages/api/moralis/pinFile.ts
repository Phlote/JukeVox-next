import { NextApiRequest, NextApiResponse } from "next";
import { pinFile } from "../../../utils/moralis";
import { supabase } from "../../../lib/supabase";
import sanitize from "sanitize-filename";

export const config = {
  api: {
    bodyParser: {
      sizeLimit: "50mb",
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
  const { url, id } = request.body;

  let fileName = sanitize(id.replace(/[^a-z0-9]/gi, '_').toLowerCase());// Make sure filename is valid for Moralis

  let remoteFileResponse = await supabase.storage.from('files').download(id) as {data: Blob, error: Error};
  let blob = remoteFileResponse.data;
  let b64File = toBase64(await blob.arrayBuffer());

  try {
    const deleteFiles = await supabase
      .storage
      .from('files')
      .remove([id])

    if (deleteFiles.error) throw deleteFiles.error;
  } catch (e) {
    console.error(e);
  }

  try {
    const res = await pinFile(b64File as string, fileName as string);
    response.status(200).send(res);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}
