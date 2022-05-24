import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import Image from "next/image";
import Link from "next/link";
import React from "react";
import { toast } from "react-toastify";
import { useIsCurator } from "../hooks/useIsCurator";
import { useCurator } from "../hooks/web3/useCurator";
import { useProfile } from "./Forms/ProfileSettingsForm";

export const RatingsMeter: React.FC<{
  submissionAddress: string;
  submitterWallet: string;
  initialCosigns: Uint8Array[];
}> = (props) => {
  const { submissionAddress, submitterWallet, initialCosigns } = props;

  const { account } = useWeb3React();
  const [cosigns, setCosigns] = React.useState<string[]>([]);
  const curator = useCurator();

  React.useEffect(() => {
    if (initialCosigns) {
      setCosigns(
        initialCosigns.map((address) => ethers.utils.hexlify(address))
      );
    }
  }, [initialCosigns]);

  const isCurator = useIsCurator();

  const canCosign =
    isCurator &&
    !cosigns.includes("pending") &&
    !cosigns.includes(account) &&
    submitterWallet.toLowerCase() !== account.toLowerCase();

  const onCosign = async (e) => {
    e.stopPropagation();
    setCosigns([...cosigns, "pending"]);
    try {
      const txn = await curator.curate(submissionAddress);
    } catch (e) {
      console.error(e);
      toast.error(e.message);
      setCosigns((current) => current.slice(0, current.length - 1));
    }
  };

  return (
    <div className={`flex gap-1 justify-center `}>
      {Array(5)
        .fill(null)
        .map((_, idx) => {
          if (idx > cosigns.length - 1) {
            return (
              <button
                key={`${submissionAddress}-cosign-${idx}`}
                onClick={onCosign}
                className={`h-6 w-6 relative ${
                  canCosign ? "hover:opacity-25 cursor-pointer" : undefined
                }`}
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
            return <Cosign wallet={cosigns[idx]} />;
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
  if (!ethers.utils.isAddress(wallet) && wallet !== "pending") {
    throw "Not a valid wallet";
  }

  const profileQuery = useProfile(wallet);

  if (wallet === "pending") {
    return (
      <div className="h-6 w-6 relative opacity-25">
        <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
      </div>
    );
  }

  if (
    profileQuery?.data &&
    profileQuery.data?.username &&
    profileQuery.data?.profilePic
  )
    return (
      <Link
        href={"/profile/[userId]"}
        as={`/profile/${profileQuery.data.username}`}
        passHref
      >
        <div className="h-6 w-6 relative rounded-full cursor-pointer hover:opacity-25">
          <Image
            className="rounded-full"
            src={profileQuery.data.profilePic}
            alt={`${wallet} cosign`}
            layout="fill"
          />
        </div>
      </Link>
    );

  // No profile data
  return (
    <div className="h-6 w-6 relative">
      <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
    </div>
  );
};
