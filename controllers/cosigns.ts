import { toast } from "react-toastify";
import { nextApiRequest } from "../utils";

export const cosign = async (
  submissionId: number,
  cosignerWallet: string
): Promise<string[]> => {
  try {
    const { cosigns } = await nextApiRequest("cosign", "POST", {
      submissionId,
      cosignerWallet,
    });
    return cosigns;
  } catch (e) {
    console.log("actually here:", e);
    toast.error(e);
    console.error(e);
  }
};
