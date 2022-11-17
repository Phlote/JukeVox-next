import { nextApiRequest } from "../utils";

export const cosign = async (
  submissionID: number,
  cosignerWallet: string
): Promise<string[]> => {
  const { cosigns } = await nextApiRequest("cosign", "POST", {
    submissionID,
    cosignerWallet,
  });
  return cosigns;
};
