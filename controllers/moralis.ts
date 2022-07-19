import { nextApiRequest } from "../utils";

const toBase64 = (file: File) =>
  new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = (error) => reject(error);
  });

export const pinFile = async (file: File) => {
  const res = await nextApiRequest("moralis/pinFile", "POST", {
    b64File: await toBase64(file),
    name: file.name,
  });
  return res as { uri: string; hash: string };
};
