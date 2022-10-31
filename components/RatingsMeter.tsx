import { ethers } from "ethers";
import Image from "next/image";
import Link from "next/link";
import React, { useState } from "react";
import { toast } from "react-toastify";
import { cosign } from "../controllers/cosigns";
import { useIsCurator } from "../hooks/useIsCurator";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import { CuratorABI, CuratorAddress } from "../solidity/utils/Curator";
import { ContractRes } from "../types";
import { PhloteVoteABI, PhloteVoteAddress } from "../solidity/utils/PhloteVote";

const phloteTokenCosts = [50, 60, 70, 80, 90];

export const RatingsMeter: React.FC<{
  submissionId: number;
  submitterWallet: string;
  initialCosigns: string[];
}> = (props) => {
  const { submissionId, submitterWallet, initialCosigns } = props;

  const { isWeb3Enabled, account } = useMoralis();
  const { fetch: runContractFunction, data, error, isLoading, isFetching, } = useWeb3ExecuteFunction();
  const [contractRes, setContractRes] = useState<ContractRes>({});
  const [approvalRes, setApprovalRes] = useState<ContractRes>({});

  const [cosigns, setCosigns] = React.useState<string[]>([]);

  React.useEffect(() => {
    if (initialCosigns) {
      setCosigns(initialCosigns);
    }
  }, [initialCosigns]);

  const isCuratorQuery = useIsCurator();

  const canCosign = account &&
    isCuratorQuery?.data?.isCurator &&
    !cosigns.includes("pending") &&
    !cosigns.includes(account) &&
    submitterWallet?.toLowerCase() !== account.toLowerCase();

  const onCosign = async (e) => {
    e.stopPropagation();
    setCosigns([...cosigns, "pending"]);
    try {
      if (!isWeb3Enabled) {
        throw "Authentication failed";
      }
      
      if (true) { // TODO: Is artist submission? Gotta fetch this from new DB
        const optionsApproval = {
          abi: PhloteVoteABI,
          contractAddress: PhloteVoteAddress,
          functionName: "approve",
          params: {
            spender: CuratorAddress,
            amount: phloteTokenCosts[cosigns.length]
          },
        }

        await runContractFunction({
          params: optionsApproval,
          onError: (err) => {
            setApprovalRes(err);
            throw err;
          },
          onSuccess: (res) => {
            console.log(res);
            setApprovalRes(res);
          },
        });
      }

      const optionsContract = {
        abi: CuratorABI,
        contractAddress: CuratorAddress,
        functionName: "curate",
        params: {
          _hotdrop: '0xb3727e8fa83e7a913a8c13bad9c2b70f83279782' // need the hotdrop hash here from db
        },
      }

      await runContractFunction({
        params: optionsContract,
        onError: (err) => {
          setContractRes(err);
          throw err;
        },
        onSuccess: (res) => {
          console.log(res);
          setContractRes(res);
        },
      });

      const newCosigns = await cosign(submissionId, account);
      if (newCosigns) {
        setCosigns(newCosigns);
      }
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
                key={`${submissionId}-cosign-${idx}`}
                onClick={onCosign}
                className={`h-6 w-6 relative ${
                  canCosign ? "hover:opacity-25 cursor-pointer" : undefined
                }`}
                disabled={!canCosign}
              >
                <Image
                  src="/blue_diamond.png"
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
                  onClick={(e) => e.stopPropagation()}
                >
                  <Cosign wallet={cosigns[idx]} />
                </div>
              );
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

  if (profileQuery?.isLoading) {
    return (
      <div className="h-full w-full opacity-25">
        <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
      </div>
    );
  }

  if (
    profileQuery?.data &&
    profileQuery.data?.profilePic
  )
    return (
      <Link
        href={"/profile/[uuid]"}
        as={`/profile/${wallet}`}
        passHref
      >
        <a className="h-full w-full rounded-full cursor-pointer hover:opacity-25">
          <Image
            className="rounded-full"
            src={profileQuery.data.profilePic}
            alt={`${wallet} cosign`}
            layout="fill"
          />
        </a>
      </Link>
    );

  return (
    <Link href={"/profile/[uuid]"} as={`/profile/${wallet}`} passHref>
      <a className="h-full w-full rounded-full cursor-pointer hover:opacity-25">
        <Image src="/default.png" alt="cosigned" layout="fill" />
      </a>
    </Link>
  );
};
