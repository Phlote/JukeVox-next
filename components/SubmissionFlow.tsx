import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import { FC, useEffect, useState } from "react";
import { useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { uploadIpfs } from "../pages/ipfs";
// import { revalidate } from "../controllers/revalidate";
// import { submit } from "../controllers/submissions";
import { Submission } from "../types";
// import { verifyUser } from "../utils/web3";
import { uploadFiles } from "./FileUpload";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { SubmissionForm } from "./Forms/SubmissionForm";
import { HollowButton, HollowButtonContainer } from "./Hollow";
import { APP_NAME, LENSHUB_PROXY } from "../utils/constants";
import { LensHubProxy } from "../abis/LensHubProxy";
import { v4 as uuid } from "uuid";
import { useContractWrite, useSignTypedData } from "wagmi";
import { gql } from "@apollo/client";
import { apollo } from "../pages/apollo";
import { omit } from "../lib/omit";
import { splitSignature } from "../lib/splitSignature";

const submissionFlowOpen = atom<boolean>(false);
export const useSubmissionFlowOpen = () => useAtom(submissionFlowOpen);

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

export const SubmissionFlow: FC = (props) => {
  const { account, library } = useWeb3React();
  const queryClient = useQueryClient();

  const [page, setPage] = useState<number>(0);
  const [path, setPath] = useState<string>("");
  const [fileSelected, setFileSelected] = useState<File>();

  const [open] = useSubmissionFlowOpen();
  useEffect(() => {
    if (!open) setPage(0);
  }, [open]);

  const [ipfsLoading, setIpfsLoading] = useState<boolean>(false);
  const [transactionLoading, setTransactionLoading] = useState<boolean>(false);

  const profile = useProfile(account);

  const { signTypedDataAsync } = useSignTypedData({
    onError(error) {
      toast.error(error?.message);
      setTransactionLoading(false);
    },
  });
  const { data: songData, write: createSong } = useContractWrite({
    addressOrName: LENSHUB_PROXY,
    contractInterface: LensHubProxy,
    functionName: "postWithSig",
    mode: "recklesslyUnprepared",
    onSuccess() {
      setTransactionLoading(false);
      setPage(1);
    },
    onError(error: any) {
      toast.error(error);
      setTransactionLoading(false);
    },
  });

  const createPost = async (submission: Submission) => {
    if (fileSelected) {
      const moralisAudioURL = await uploadFiles({
        acceptedFile: fileSelected,
      });
      submission.mediaURI = moralisAudioURL;
    }

    setIpfsLoading(true);
    const { path } = await uploadIpfs({
      version: "1.0.0",
      metadata_id: uuid(),
      description: `Song by @${submission.artistName}`,
      content: submission.mediaURI,
      external_url: null,
      image: null,
      imageMimeType: null,
      name: submission.mediaTitle,
      attributes: [
        {
          traitType: "string",
          key: "type",
          value: "song",
        },
      ],
      media: null,
      mediaType: submission.mediaType,
      marketplace: submission.marketplace,
      createdOn: new Date(),
      appId: APP_NAME,
    }).finally(() => {
      setPath(path);
      setIpfsLoading(false);
    });

    setTransactionLoading(true);
    const createPostRequest = {
      profileId: "0x4318",
      contentURI: `https://ipfs.infura.io/ipfs/${path}`,
      collectModule: { freeCollectModule: { followerOnly: false } },
      referenceModule: {
        followerOnlyReferenceModule: false,
      },
    };

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
  };

  // const onSubmit = async (submission: Submission) => {
  //   setLoading(true);
  //   try {
  //     const authenticated = await verifyUser(account, library);
  //     if (!authenticated) {
  //       throw "Not Authenticated";
  //     }
  //     if (fileSelected) {
  //       const moralisAudioURL = await uploadFiles({
  //         acceptedFile: fileSelected,
  //       });
  //       submission.mediaURI = moralisAudioURL;
  //     }

  //     const result = (await submit(submission, account)) as Submission;

  //     setPage(1);
  //     queryClient.invalidateQueries("submissions");
  //     await revalidate(profile?.data?.username, result.id);
  //   } catch (e) {
  //     toast.error(e);
  //     console.error(e);
  //   } finally {
  //     setLoading(false);
  //   }
  // };

  return (
    <div className="flex flex-col w-full sm:mx-8 justify-center sm:py-16 pt-4">
      <h1 className="font-extrabold	text-4xl underline underline-offset-16 text-center">
        Submit
      </h1>
      <div className="h-8" />
      {page === 0 && (
        <SubmissionForm
          ipfsLoading={ipfsLoading}
          transactionLoading={transactionLoading}
          onSubmit={createPost}
          fileSelected={fileSelected}
          setFileSelected={setFileSelected}
        />
      )}
      {page === 1 && (
        <div className="flex flex-col items-center text-sm mt-8 gap-8">
          <p>Congratulations! Your submission has been added</p>
          {/* <a
            className="underline flex"
            rel="noreferrer"
            target="_blank"
            href={`https://rinkeby.etherscan.io/tx/${txnHash}`}
          >
            View Transaction
            <div className="w-1" />
            <Image src="/arrow.svg" alt={"link"} height={12} width={12} />
          </a>
          <div className="h-4" />
          <a
            className="underline flex"
            rel="noreferrer"
            target="_blank"
            style={
              nftMintId === "Loading"
                ? { pointerEvents: "none", opacity: 0.5 }
                : undefined
            }
            href={`https://testnets.opensea.io/assets/${NFT_MINT_CONTRACT_RINKEBY}/${nftMintId.toString()}`}
          >
            View NFT on Opensea
            {nftMintId === "Loading" && " (Waiting on transaction...)"}
            <div className="w-1" />
            <Image src="/arrow.svg" alt={"link"} height={12} width={12} />
          </a> */}

          <HollowButtonContainer className="w-1/2" onClick={() => setPage(0)}>
            <HollowButton>Submit Another</HollowButton>
          </HollowButtonContainer>
        </div>
      )}
    </div>
  );
};
