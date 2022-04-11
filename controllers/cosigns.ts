import { nextApiRequest } from "../utils";

export const cosign = async (
  submissionId: number,
  cosignerWallet: string
): Promise<string[]> => {
  const { cosigns } = await nextApiRequest("cosign", "POST", {
    submissionId,
    cosignerWallet,
  });
  return cosigns;
};
