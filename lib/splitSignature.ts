import { utils } from "ethers";

export const splitSignature = (signature: string) => {
  return utils.splitSignature(signature);
};
