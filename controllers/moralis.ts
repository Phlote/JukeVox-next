import { nextApiRequest } from "../utils";

export const pinFile = async (file: File) => {
  const ipfs = await nextApiRequest("moralis/pinFile", "POST", {
    b64File: file,
    name: file.name,
  });
  return ipfs as unknown as string;
};
