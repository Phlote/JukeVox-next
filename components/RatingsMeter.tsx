import { ethers } from "ethers";
import Image from "next/image";
import Link from "next/link";
import React, { useEffect, useState } from "react";
import { toast } from "react-toastify";
import { cosign } from "../controllers/cosigns";
import { useIsCurator } from "../hooks/useIsCurator";
import { useProfile } from "./Forms/ProfileSettingsForm";
import ReactTooltip from "react-tooltip";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import { CuratorABI, CuratorAddress } from "../solidity/utils/Curator";
import { ContractRes } from "../types";
import { PhloteVoteABI, PhloteVoteAddress } from "../solidity/utils/PhloteVote";

const phloteTokenCosts = [50, 60, 70, 80, 90];

export const RatingsMeter: React.FC<{
  // TODO: Use submission interface instead
  submissionID: string;
  submitterWallet: string;
  initialCosigns: string[];
  isArtist: boolean;
  hotdropAddress: string;
}> = (props) => {
  const { submissionID, submitterWallet, initialCosigns, isArtist, hotdropAddress } = props;

  const { isWeb3Enabled, account } = useMoralis();
  const { fetch: runContractFunction, data, error, isLoading, isFetching, } = useWeb3ExecuteFunction();
  const [contractRes, setContractRes] = useState<ContractRes>({});
  const [approvalRes, setApprovalRes] = useState<ContractRes>({});

  const [cosigns, setCosigns] = useState<string[]>([]);

  useEffect(() => ReactTooltip.rebuild() as () => (void), []);

  useEffect(() => {
    if (initialCosigns) {
      setCosigns(initialCosigns);
    }
  }, [initialCosigns]);

  const isCuratorData = useIsCurator();
  const isCurator = isCuratorData.data?.isCurator;

  const canCosign = account &&
    isCurator &&
    !cosigns.includes("pending") &&
    !cosigns.includes(account) &&
    submitterWallet?.toLowerCase() !== account.toLowerCase();

  let cantCosignMessage = '';
  if (account) {
    if (!isCurator) {
      cantCosignMessage = 'Need phlote tokens to cosign.';
    }
    if (submitterWallet?.toLowerCase() === account.toLowerCase()) {
      cantCosignMessage = "Can't cosign own submission."
    }
  } else {
    cantCosignMessage = 'Connect your wallet to cosign.';
  }

  const onCosign = async (e) => {
    e.stopPropagation();
    setCosigns([...cosigns, "pending"]);
    try {
      if (!isWeb3Enabled) {
        throw "Authentication failed";
      }

      console.log('PHLOTE TOKEN AMMOUNT', phloteTokenCosts[cosigns.length]);

      if (isArtist) {
        const optionsApproval = {
          abi: PhloteVoteABI,
          contractAddress: PhloteVoteAddress,
          functionName: "approve",
          params: {
            spender: CuratorAddress,
            amount: phloteTokenCosts[cosigns.length]
          },
        }

        const approvalTransaction = await runContractFunction({
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

        // @ts-ignore
        await approvalTransaction.wait();
      }

      const optionsContract = {
        abi: CuratorABI,
        contractAddress: CuratorAddress,
        functionName: "curate",
        params: {
          _hotdrop: hotdropAddress
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

      const newCosigns = await cosign(submissionID, account);
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
    <div className={`flex gap-1 justify-center `} data-tip={cantCosignMessage}>
      {Array(5)
        .fill(null)
        .map((_, idx) => {
          if (idx > cosigns.length - 1) {
            return (
              <button
                key={`${submissionID}-cosign-${idx}`}
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
                  key={`${submissionID}-cosign-${idx}`}
                >
                  <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
                </div>
              );
            } else {
              return (
                <div
                  key={`${submissionID}-cosign-${idx}`}
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
