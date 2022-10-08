import { BigNumber, utils } from "ethers";
import { v4 as uuidv4 } from "uuid";
import { apollo } from "../lib/apollo";
import {
  useContractWrite,
  useSignTypedData,
  useWaitForTransaction,
} from "wagmi";
import { omit } from "../lib/omit";
import { splitSignature } from "../lib/splitSignature";
import {
  CreateCommentTypedDataDocument,
  CreatePublicCommentRequest,
  CreateCommentViaDispatcherDocument,
} from "../utils/graphql/generated";
import { LensHubProxy } from "../abis/LensHubProxy";
import { LENSHUB_PROXY } from "../utils/constants";
import { pollUntilIndexed } from "../utils/indexing_transacrions";
import React from "react";
import { toast } from "react-toastify";
import { uploadIpfs } from "../lib/ipfs";
import { APP_NAME } from "../utils/constants";

const createCommentTypedData = async (request: CreatePublicCommentRequest) => {
  const result = await apollo.mutate({
    mutation: CreateCommentTypedDataDocument,
    variables: {
      request,
    },
  });

  return result.data!.createCommentTypedData;
};

const createCommentViaDispatcherRequest = async (
  request: CreatePublicCommentRequest
) => {
  const result = await apollo.mutate({
    mutation: CreateCommentViaDispatcherDocument,
    variables: {
      request,
    },
  });

  return result.data!.createCommentViaDispatcher;
};

export const Comment: React.FC<{
  profileId: string;
  publicationId: string;
}> = (props) => {
  const { profileId, publicationId } = props;

  if (!profileId) {
    throw new Error("Lens profile not found");
  }

  const { data, write } = useContractWrite({
    addressOrName: LENSHUB_PROXY,
    contractInterface: LensHubProxy,
    functionName: "commentWithSig",
    mode: "recklesslyUnprepared",
    onError(error) {
      toast.error(error);
    },
  });

  const { isLoading } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess() {
      toast.success("You commented");
    },
  });

  const { signTypedDataAsync } = useSignTypedData({
    onError(error) {
      console.error(error);
    },
  });

  const comment = async () => {
    try {
      const { path } = await uploadIpfs({
        version: "2.0.0",
        mainContentFocus: "TEXT_ONLY",
        metadata_id: uuidv4(),
        description: "Description",
        locale: "en-US",
        content: "This is where the comment will be filled",
        external_url: null,
        image: null,
        imageMimeType: null,
        name: "Name",
        attributes: [],
        tags: ["tags examples"],
        appId: APP_NAME,
      });

      const createCommentRequest = {
        profileId,
        publicationId,
        contentURI: `https://ipfs.infura.io/ipfs/${path}`,
        collectModule: {
          revertCollectModule: true,
        },
        referenceModule: {
          followerOnlyReferenceModule: false,
        },
      };

      const result = await createCommentTypedData(createCommentRequest);

      const resultTypedData = result.typedData;

      const signature = await signTypedDataAsync({
        domain: omit(resultTypedData?.domain, "__typename"),
        types: omit(resultTypedData?.types, "__typename"),
        value: omit(resultTypedData?.value, "__typename"),
      });

      const typedData = result.typedData;

      const { v, r, s } = splitSignature(signature);
      const inputStruct = {
        profileId: typedData.value.profileId,
        profileIdPointed: typedData.value.profileIdPointed,
        pubIdPointed: typedData.value.pubIdPointed,
        referenceModuleData: typedData.value.referenceModuleData,
        referenceModule: typedData.value.referenceModule,
        referenceModuleInitData: typedData.value.referenceModuleInitData,
        sig: {
          v,
          r,
          s,
          deadline: typedData.value.deadline,
        },
      };

      write?.({ recklesslySetUnpreparedArgs: inputStruct });
      toast.success("comment completed!");
    } catch (error) {
      toast.error(error);
    }
  };

  return (
    <div>
      <button onClick={() => comment()}>
        {isLoading ? "Commenting..." : "Comment"}
      </button>
    </div>
  );
};

export const CommentWithDispatcher: React.FC<{
  profileId: string;
  publicationId: string;
}> = (props) => {
  const { profileId, publicationId } = props;
  const [isLoading, setIsLoading] = React.useState<boolean>(false);

  if (!profileId) {
    throw new Error("Lens profile not found");
  }

  const commentWithDispatcher = async () => {
    try {
      setIsLoading(true);

      const { path } = await uploadIpfs({
        version: "2.0.0",
        mainContentFocus: "TEXT_ONLY",
        metadata_id: uuidv4(),
        description: "Description",
        locale: "en-US",
        content: "This is where the comment will be filled",
        external_url: null,
        image: null,
        imageMimeType: null,
        name: "Name",
        attributes: [],
        tags: ["tags examples"],
        appId: APP_NAME,
      });

      const createCommentRequest = {
        profileId,
        publicationId,
        contentURI: `https://ipfs.infura.io/ipfs/${path}`,
        collectModule: {
          revertCollectModule: true,
        },
        referenceModule: {
          followerOnlyReferenceModule: false,
        },
      };

      const result = await createCommentViaDispatcherRequest(
        createCommentRequest
      );
      const indexedResult = await pollUntilIndexed({ txId: result.txId });

      const logs = indexedResult.txReceipt!.logs;

      const topicId = utils.id(
        "commentCreated(uint256,uint256,uint256,uint256,bytes,address,bytes,uint256)"
      );

      const profileCreatedLog = logs.find((l: any) => l.topics[0] === topicId);

      let profileCreatedEventLog = profileCreatedLog!.topics;

      const pubId = utils.defaultAbiCoder.decode(
        ["uint256"],
        profileCreatedEventLog[2]
      )[0];

      console.log(
        "create comment: contract publication id",
        BigNumber.from(pubId).toHexString()
      );
      console.log(
        "create comment: internal publication id",
        profileId + "-" + BigNumber.from(pubId).toHexString()
      );

      setIsLoading(false);
      toast.success("comment completed!");

      return result;
    } catch (error) {
      setIsLoading(false);
      toast.error(error);
    }
  };

  return (
    <div>
      <button onClick={() => commentWithDispatcher()}>
        {isLoading ? "Commenting..." : "Comment gasless"}
      </button>
    </div>
  );
};
