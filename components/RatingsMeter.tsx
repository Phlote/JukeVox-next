import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import Image from "next/image";
import Link from "next/link";
import React from "react";
import { useQuery } from "react-query";
import { toast } from "react-toastify";
import { useIsCurator } from "../hooks/useIsCurator";
import { useCurator } from "../hooks/web3/useCurator";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetCosignsForSubmissionDocument,
  GetCosignsForSubmissionQuery,
} from "../lib/graphql/generated";
import { useProfile } from "./Forms/ProfileSettingsForm";

export const RatingsMeter: React.FC<{
  submissionAddress: string;
  submitterWallet: string;
  initialCosigns: Uint8Array[];
}> = (props) => {
  const { submissionAddress, submitterWallet, initialCosigns } = props;

  const { account } = useWeb3React();
  const [cosigns, setCosigns] = React.useState<string[]>([]);
  const [polling, setPolling] = React.useState<boolean>(false);
  const curator = useCurator();

  React.useEffect(() => {
    if (initialCosigns) {
      setCosigns(
        initialCosigns.map((address) => ethers.utils.hexlify(address))
      );
    }
  }, [initialCosigns]);

  const client = initializeApollo();

  const cosignsPollQuery = useQuery(
    ["cosigns", submissionAddress],
    async () => {
      const res = await client.query<GetCosignsForSubmissionQuery>({
        query: GetCosignsForSubmissionDocument,
        variables: { id: submissionAddress },
        fetchPolicy: "network-only",
      });

      return res?.data?.submission?.cosigns?.map((address) =>
        ethers.utils.hexlify(address)
      );
    },
    {
      refetchInterval: 1000,
      refetchIntervalInBackground: true,
      enabled: polling,
    }
  );

  React.useEffect(() => {
    if (cosignsPollQuery.data && polling && cosigns.includes("pending")) {
      // if the cosigns we have in the db are one more than we have (at this stage, cosigns must have pending)
      if (cosignsPollQuery.data.length === cosigns.length) {
        console.log("new cosign found");
        setCosigns(cosignsPollQuery.data);
        setPolling(false);
      } else console.log("still no new cosign");
    }
  }, [cosignsPollQuery, polling, cosigns]);

  const isCurator = useIsCurator();

  const canCosign = isCurator;
  // !cosigns.includes("pending") &&
  // !cosigns.includes(account) &&
  // submitterWallet.toLowerCase() !== account.toLowerCase();

  const onCosign = async (e) => {
    e.stopPropagation();
    setCosigns([...cosigns, "pending"]);
    try {
      const txn = await curator.curate(submissionAddress);
      setPolling(true);
      console.log(polling);
    } catch (e) {
      console.error(e);
      toast.error(e.message);
      setCosigns((current) => current.slice(0, current.length - 1));
      setPolling(false);
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
            return (
              <div className="relative h-6 w-6">
                <Cosign wallet={cosigns[idx]} />
              </div>
            );
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
      <div className="h-full w-full opacity-25">
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
        <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
      </a>
    </Link>
  );
};
