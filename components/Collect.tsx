import { apollo } from "../lib/apollo";
import {
  useContractWrite,
  useSignTypedData,
  useWaitForTransaction,
} from "wagmi";
import { omit } from "../lib/omit";
import { splitSignature } from "../lib/splitSignature";
import {
  CreateCollectRequest,
  CreateCollectTypedDataDocument,
} from "../utils/graphql/generated";
import { LensHubProxy } from "../abis/LensHubProxy";
import { LENSHUB_PROXY } from "../utils/constants";
import React from "react";
import { toast } from "react-toastify";

const createCollectTypedData = async (request: CreateCollectRequest) => {
  const result = await apollo.mutate({
    mutation: CreateCollectTypedDataDocument,
    variables: {
      request,
    },
  });

  return result.data!.createCollectTypedData;
};

export const Collect: React.FC<{
  profileId: string;
  publicationId: string;
  profileAddress: string;
}> = (props) => {
  const { profileId, publicationId, profileAddress } = props;

  if (!profileId) {
    throw new Error("Lens profile not found");
  }

  const createCollectRequest = {
    publicationId,
  };

  const { data, write } = useContractWrite({
    addressOrName: LENSHUB_PROXY,
    contractInterface: LensHubProxy,
    functionName: "collectWithSig",
    mode: "recklesslyUnprepared",
    onError(error: any) {
      console.error(error?.data?.message ?? error?.message);
    },
  });

  const { isLoading } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess() {
      toast.success("You Collected");
    },
  });

  const { signTypedDataAsync } = useSignTypedData({
    onError(error) {
      console.error(error);
    },
  });

  const Collect = async () => {
    try {
      const result = await createCollectTypedData(createCollectRequest);

      const resultTypedData = result.typedData;

      const signature = await signTypedDataAsync({
        domain: omit(resultTypedData?.domain, "__typename"),
        types: omit(resultTypedData?.types, "__typename"),
        value: omit(resultTypedData?.value, "__typename"),
      });

      const typedData = result.typedData;

      const { v, r, s } = splitSignature(signature);
      const inputStruct = {
        collector: profileAddress,
        profileId: typedData.value.profileId,
        pubId: typedData.value.pubId,
        data: typedData.value.data,
        sig: {
          v,
          r,
          s,
          deadline: typedData.value.deadline,
        },
      };

      console.log(inputStruct);

      write?.({ recklesslySetUnpreparedArgs: inputStruct });
      console.log("test");
    } catch (error) {
      console.error(error.message);
    }
  };

  return (
    <div>
      <button onClick={() => Collect()}>
        {isLoading ? "Collecting..." : "Collect"}
      </button>
    </div>
  );
};
