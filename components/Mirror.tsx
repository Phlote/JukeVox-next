import { BigNumber, utils } from "ethers";
import { apollo } from "../lib/apollo";
import {
  useContractWrite,
  useSignTypedData,
  useWaitForTransaction,
} from "wagmi";
import { omit } from "../lib/omit";
import { splitSignature } from "../lib/splitSignature";
import {
  CreateMirrorRequest,
  CreateMirrorTypedDataDocument,
  CreateMirrorViaDispatcherDocument,
} from "../utils/graphql/generated";
import { LensHubProxy } from "../abis/LensHubProxy";
import { LENSHUB_PROXY } from "../utils/constants";
import { pollUntilIndexed } from "../utils/indexing_transacrions";
import React from "react";
import { toast } from "react-toastify";

const createMirrorTypedData = async (request: CreateMirrorRequest) => {
  const result = await apollo.mutate({
    mutation: CreateMirrorTypedDataDocument,
    variables: {
      request,
    },
  });

  return result.data!.createMirrorTypedData;
};

const createMirrorViaDispatcherRequest = async (
  request: CreateMirrorRequest
) => {
  const result = await apollo.mutate({
    mutation: CreateMirrorViaDispatcherDocument,
    variables: {
      request,
    },
  });

  return result.data!.createMirrorViaDispatcher;
};

export const Mirror: React.FC<{
  profileId: string;
  publicationId: string;
}> = (props) => {
  const { profileId, publicationId } = props;

  if (!profileId) {
    throw new Error("Lens profile not found");
  }

  const createMirrorRequest = {
    profileId,
    publicationId,
    referenceModule: {
      followerOnlyReferenceModule: false,
    },
  };

  const { data, write } = useContractWrite({
    addressOrName: LENSHUB_PROXY,
    contractInterface: LensHubProxy,
    functionName: "mirrorWithSig",
    mode: "recklesslyUnprepared",
    onError(error) {
      toast.error(error);
    },
  });

  const { isLoading } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess() {
      toast.success("You mirrored");
    },
  });

  const { signTypedDataAsync } = useSignTypedData({
    onError(error) {
      console.error(error);
    },
  });

  const mirror = async () => {
    try {
      const result = await createMirrorTypedData(createMirrorRequest);

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
      toast.success("Mirror completed!");
    } catch (error) {
      toast.error(error);
    }
  };

  return (
    <div>
      <button onClick={() => mirror()}>
        {isLoading ? "Mirroring..." : "Mirror"}
      </button>
    </div>
  );
};

export const MirrorWithDispatcher: React.FC<{
  profileId: string;
  publicationId: string;
}> = (props) => {
  const { profileId, publicationId } = props;
  const [isLoading, setIsLoading] = React.useState<boolean>(false);

  if (!profileId) {
    throw new Error("Lens profile not found");
  }

  const createMirrorRequest = {
    profileId,
    publicationId,
    referenceModule: {
      followerOnlyReferenceModule: false,
    },
  };

  const mirrorWithDispatcher = async () => {
    try {
      setIsLoading(true);
      const result = await createMirrorViaDispatcherRequest(
        createMirrorRequest
      );

      console.log("create mirror gasless", result);

      console.log("create mirror: poll until indexed");
      const indexedResult = await pollUntilIndexed({ txId: result.txId });

      console.log("create mirror: profile has been indexed", result);

      const logs = indexedResult.txReceipt!.logs;

      console.log("create mirror: logs", logs);

      const topicId = utils.id(
        "MirrorCreated(uint256,uint256,uint256,uint256,bytes,address,bytes,uint256)"
      );
      console.log("topicid we care about", topicId);

      const profileCreatedLog = logs.find((l: any) => l.topics[0] === topicId);
      console.log("create mirror: created log", profileCreatedLog);

      let profileCreatedEventLog = profileCreatedLog!.topics;
      console.log("create mirror: created event logs", profileCreatedEventLog);

      const publicationId = utils.defaultAbiCoder.decode(
        ["uint256"],
        profileCreatedEventLog[2]
      )[0];

      console.log(
        "create mirror: contract publication id",
        BigNumber.from(publicationId).toHexString()
      );
      console.log(
        "create mirror: internal publication id",
        profileId + "-" + BigNumber.from(publicationId).toHexString()
      );

      setIsLoading(false);
      toast.success("Mirror completed!");

      return result;
    } catch (error) {
      setIsLoading(false);
      toast.error(error);
    }
  };

  return (
    <div>
      <button onClick={() => mirrorWithDispatcher()}>
        {isLoading ? "Mirroring..." : "Mirror gasless"}
      </button>
    </div>
  );
};
