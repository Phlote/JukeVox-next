import { nextApiRequest } from "../utils";



export const pinFile = async (url: string, name: string) => {
  const res = await nextApiRequest("moralis/pinFile", "POST", { url, name });
  return res as { uri: string; hash: string };
};
