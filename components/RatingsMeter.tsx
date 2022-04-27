import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import Image from "next/image";
import React from "react";
import { toast } from "react-toastify";
import { cosign } from "../controllers/cosigns";
import { useIsCurator } from "../hooks/useIsCurator";
import { verifyUser } from "../utils/web3";
import { useProfile } from "./Forms/ProfileSettingsForm";

export const RatingsMeter: React.FC<{
  submissionId: number;
  submitterWallet: string;
  initialCosigns: string[];
}> = (props) => {
  const { submissionId, submitterWallet, initialCosigns } = props;

  const { account, library } = useWeb3React();
  const [cosigns, setCosigns] = React.useState<string[]>([]);

  React.useEffect(() => {
    if (initialCosigns) {
      setCosigns(initialCosigns);
    }
  }, [initialCosigns]);

  const isCuratorQuery = useIsCurator();

  const canCosign =
    isCuratorQuery?.data?.isCurator &&
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
      const newCosigns = await cosign(submissionId, account);
      if (newCosigns) setCosigns(newCosigns);
    } catch (e) {
      console.error(e);
      toast.error(e.message);
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
              return <Cosign wallet={cosigns[idx]} />;
            }
          }
        })}
    </div>
  );
};

interface Cosign {
  wallet: string;
}

const Cosign: React.FC<Cosign> = (props) => {
  const { wallet } = props;
  if (!ethers.utils.isAddress(wallet)) {
    throw "Not a valid wallet";
  }

  const profileQuery = useProfile(wallet);

  if (profileQuery?.data?.profilePic)
    return (
      <div className="h-6 w-6 relative">
        <Image
          src={profileQuery.data.profilePic}
          alt={`${wallet} cosign`}
          layout="fill"
        />
      </div>
    );
  else
    return (
      <div className="h-6 w-6 opacity-25 relative">
        <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
      </div>
    );
};
