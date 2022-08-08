import { apollo } from "../../pages/apollo";
import { gql } from "@apollo/client";
import Image from "next/image";
import { useConnect, useAccount, useSignMessage } from "wagmi";

const CREATE_PROFILE = `
  mutation($request: CreateProfileRequest!) { 
    createProfile(request: $request) {
      ... on RelayerResult {
        txHash
      }
      ... on RelayError {
        reason
      }
            __typename
    }
 }
`;

export const createProfile = () => {
  return apollo.mutate({
    mutation: gql(CREATE_PROFILE),
    variables: {
      request: {
        handle: "alicephlote",
        profilePictureUri: null,
        followModule: {
          freeFollowModule: true,
        },
      },
    },
  });
};

export const CreateProfileLens = () => {
  //   const { connect, connectors } = useConnect();
  //   const { address, connector: activeConnector } = useAccount();

  //   const { signMessageAsync, isLoading: signLoading } = useSignMessage({
  //     onError(error) {
  //       console.error(error);
  //     },
  //   });

  const handleSign = async () => {
    try {
      const result = await createProfile();
      console.log(result);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <>
      <div
        className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center"
        onClick={() => {
          handleSign();
        }}
      >
        Create Profile
        <div className="w-4" />
        <Image src="/exit.svg" alt={"disconnect"} height={24} width={24} />
      </div>
    </>
  );
};
