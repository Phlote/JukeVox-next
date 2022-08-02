import { nextApiRequest } from "../utils";



export const pinFile = async (url: string) => {
  const res = await nextApiRequest("moralis/pinFile", "POST", {
    url: url,
  });
  return res as { uri: string; hash: string };
};
