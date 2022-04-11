import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import React from "react";
import { useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { cosign } from "../controllers/cosigns";
import { useCosigns } from "../hooks/useCosigns";
import { useIsCurator } from "../hooks/useIsCurator";
import { verifyUser } from "../utils/web3";

export const RatingsMeter: React.FC<{
  submissionId: number;
  submitterWallet: string;
}> = (props) => {
  const { submissionId, submitterWallet } = props;

  const { account, library } = useWeb3React();
  const cosignsQuery = useCosigns(submissionId);
  const queryClient = useQueryClient();
  const [cosigns, setCosigns] = React.useState<string[]>([]);

  React.useEffect(() => {
    if (cosignsQuery.data) {
      setCosigns(cosignsQuery.data);
    }
  }, [cosignsQuery.data]);

  const isCurator = useIsCurator();

  const canCosign =
    isCurator &&
    !cosigns.includes("pending") &&
    !cosigns.includes(account) &&
    submitterWallet.toLowerCase() !== account.toLowerCase();

  const onCosign = async () => {
    setCosigns([...cosigns, "pending"]);
    try {
      const authenticated = await verifyUser(account, library);
      if (!authenticated) {
        throw "Authentication failed";
      }

      const cosigns = await cosign(submissionId, account);
      setCosigns(cosigns);
    } catch (e) {
      toast.error(e);
      console.error(e);
      setCosigns((current) => current.slice(0, current.length - 1));
    }
  };

  return (
    <div
      className={`flex gap-1 justify-center ${
        canCosign ? "hover:opacity-25 cursor-pointer" : undefined
      }`}
    >
      {Array(5)
        .fill(null)
        .map((_, idx) => {
          if (idx > cosigns.length - 1) {
            return (
              <button
                key={`${submissionId}-cosign-${idx}`}
                onClick={onCosign}
                className={"h-6 w-6 relative"}
                disabled={!canCosign}
              >
                <Image
                  src="/clear_diamond.png"
                  alt="cosign here"
                  layout="fill"
                />
              </button>
            );
          } else {
            if (cosigns[idx] === "pending") {
              return (
                <div
                  className="h-6 w-6 opacity-25 relative"
                  key={`${submissionId}-cosign-${idx}`}
                >
                  <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
                </div>
              );
            } else {
              return (
                <div
                  className="h-6 w-6 relative"
                  key={`${submissionId}-cosign-${idx}`}
                >
                  <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
                </div>
              );
            }
          }
        })}
    </div>
  );
};
