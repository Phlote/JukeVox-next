import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import Image from "next/image";
import Link from "next/link";
import React from "react";
import { toast } from "react-toastify";
import { cosign } from "../controllers/cosigns";
import { useIsCurator } from "../hooks/useIsCurator";
import { verifyUser } from "../utils/web3";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { APP_NAME, LENSHUB_PROXY } from "../utils/constants";
import { LensHubProxy } from "../abis/LensHubProxy";
import { uploadIpfs } from "../lib/ipfs";
import { v4 as uuid } from "uuid";
import { useContractWrite, useSignTypedData } from "wagmi";
import { gql } from "@apollo/client";
import { apollo } from "../lib/apollo";
import { omit } from "../lib/omit";
import { splitSignature } from "../lib/splitSignature";
import { getLensProfile } from "../utils/profile";
import { pollUntilIndexed } from "../utils/indexing_transacrions";
import {
  CreatePostViaDispatcherDocument,
  CreatePublicPostRequest,
} from "../utils/graphql/generated";

import { BigNumber, utils } from "ethers";

const CREATE_POST_TYPED_DATA = `
  mutation CreatePostTypedData(
    $options: TypedDataOptions
    $request: CreatePublicPostRequest!
  ) {
    createPostTypedData(options: $options, request: $request) {
      id
      expiresAt
      typedData {
        types {
          PostWithSig {
            name
            type
          }
        }
        domain {
          name
          chainId
          version
          verifyingContract
        }
        value {
          nonce
          deadline
          profileId
          contentURI
          collectModule
          collectModuleInitData
          referenceModule
          referenceModuleInitData
        }
      }
    }
  }
`;

const createPostTypedData = (createPostTypedDataRequest: any) => {
  return apollo.mutate({
    mutation: gql(CREATE_POST_TYPED_DATA),
    variables: {
      request: createPostTypedDataRequest,
    },
  });
};

const createPostWithDispatcher = async (request: CreatePublicPostRequest) => {
  const result = await apollo.mutate({
    mutation: CreatePostViaDispatcherDocument,
    variables: {
      request,
    },
  });

  console.log(result);

  return result.data!.createPostViaDispatcher;
};

export const RatingsMeter: React.FC<{
  submissionId: number;
  submitterWallet: string;
  initialCosigns: string[];
  artistName: string;
  mediaTitle: string;
  mediaType: string;
  mediaURI: string;
  marketplace: string;
}> = (props) => {
  const {
    submissionId,
    submitterWallet,
    initialCosigns,
    artistName,
    mediaTitle,
    mediaType,
    mediaURI,
    marketplace,
  } = props;

  const { account, library } = useWeb3React();
  const [cosigns, setCosigns] = React.useState<string[]>([]);
  const [path, setPath] = React.useState<string>("");
  const profile = getLensProfile();

  const { signTypedDataAsync } = useSignTypedData({
    onError(error) {
      toast.error(error?.message);
      //setTransactionLoading(false);
    },
  });
  const { data: songData, write: createSong } = useContractWrite({
    addressOrName: LENSHUB_PROXY,
    contractInterface: LensHubProxy,
    functionName: "postWithSig",
    mode: "recklesslyUnprepared",
    onSuccess() {
      //setTransactionLoading(false);
    },
    onError(error: any) {
      toast.error(error);
      //setTransactionLoading(false);
    },
  });

  const post = async (createPostRequest: CreatePublicPostRequest) => {
    if (profile?.dispatcher?.canUseRelay) {
      const dispatcherResult = await createPostWithDispatcher(
        createPostRequest
      );

      if (dispatcherResult.__typename !== "RelayerResult") {
        console.error("create post via dispatcher: failed", dispatcherResult);
        throw new Error("create post via dispatcher: failed");
      }

      return { txHash: dispatcherResult.txHash, txId: dispatcherResult.txId };
      // signing with dispatcher
    } else {
      //signing without dispatcher
      const post = await createPostTypedData(createPostRequest);

      const typedData = post.data?.createPostTypedData.typedData;

      try {
        const signature = await signTypedDataAsync({
          domain: omit(typedData?.domain, "__typename"),
          types: omit(typedData?.types, "__typename"),
          value: omit(typedData?.value, "__typename"),
        });

        const { v, r, s } = splitSignature(signature);
        const sig = { v, r, s, deadline: typedData.value.deadline };
        const inputStruct = {
          profileId: typedData.value.profileId,
          contentURI: typedData.value.contentURI,
          collectModule: typedData.value.collectModule,
          collectModuleInitData: typedData.value.collectModuleInitData,
          referenceModule: typedData.value.referenceModule,
          referenceModuleInitData: typedData.value.referenceModuleInitData,
          sig,
        };

        createSong?.({ recklesslySetUnpreparedArgs: inputStruct });
      } catch (error) {
        toast.error(error);
      }
    }
  };

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
      const authenticated = await verifyUser(account, library);
      if (!authenticated) {
        throw "Authentication failed";
      }
      const newCosigns = await cosign(submissionId, account);
      if (newCosigns) setCosigns(newCosigns);

      // A post on Lens is published after 5 co-signs
      if (newCosigns.length == 5) {
        const { path } = await uploadIpfs({
          version: "1.0.0",
          metadata_id: uuid(),
          description: `Song by ${artistName}`,
          content: `${mediaURI}`,
          external_url: null,
          image: null,
          imageMimeType: null,
          name: `${mediaTitle}`,
          attributes: [
            {
              traitType: "string",
              key: "type",
              value: "song",
            },
            {
              traitType: "string",
              key: "mediaType",
              value: `${mediaType}`,
            },
            {
              traitType: "string",
              key: "marketplace",
              value: `${marketplace}`,
            },
          ],
          media: null,
          createdOn: new Date(),
          appId: APP_NAME,
        }).finally(() => {
          setPath(path);
          //setIpfsLoading(false);
        });

        //setTransactionLoading(true);
        const createPostRequest = {
          profileId: profile.id,
          contentURI: `https://ipfs.infura.io/ipfs/${path}`,
          collectModule: { freeCollectModule: { followerOnly: false } },
          referenceModule: {
            followerOnlyReferenceModule: false,
          },
        };

        const result = await post(createPostRequest);

        console.log("create post gasless", result);

        const indexedResult = await pollUntilIndexed({ txId: result.txId });

        console.log("create post: profile has been indexed", result);

        const logs = indexedResult.txReceipt!.logs;

        console.log("create post: logs", logs);

        const topicId = utils.id(
          "PostCreated(uint256,uint256,string,address,bytes,address,bytes,uint256)"
        );
        console.log("topicid we care about", topicId);

        const profileCreatedLog = logs.find(
          (l: any) => l.topics[0] === topicId
        );
        console.log("create post: created log", profileCreatedLog);

        let profileCreatedEventLog = profileCreatedLog!.topics;
        console.log("create post: created event logs", profileCreatedEventLog);

        const publicationId = utils.defaultAbiCoder.decode(
          ["uint256"],
          profileCreatedEventLog[2]
        )[0];

        console.log(
          "create post: contract publication id",
          BigNumber.from(publicationId).toHexString()
        );
        console.log(
          "create post: internal publication id",
          profile.id + "-" + BigNumber.from(publicationId).toHexString()
        );
        toast.success("Post created");
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
    profileQuery.data?.username &&
    profileQuery.data?.profilePic
  )
    return (
      <Link
        href={"/profile/[uuid]"}
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
