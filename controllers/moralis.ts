import { nextApiRequest } from "../utils";

const toBase64 = (file: File) =>
  new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = (error) => reject(error);
  });

export const pinFile = async (url: string) => {
  const res = await nextApiRequest("moralis/pinFile", "POST", {
    url,
  });
  return res as { uri: string; hash: string };
};
