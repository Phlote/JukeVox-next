import { nextApiRequest } from "../utils";

export const pinFile = async (url: string, id: string) => {
  const res = await nextApiRequest("moralis/pinFile", "POST", { url, id });
  return res as { uri: string; hash: string };
};
