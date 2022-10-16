import { atom, useAtom } from "jotai";
import React, { FC, useEffect, useState } from "react";
import { useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { revalidate } from "../controllers/revalidate";
import { submit } from "../controllers/submissions";
import { Submission } from "../types";
import { verifyUser } from "../utils/web3";
import { uploadFiles } from "./FileUpload";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { SubmissionForm } from "./Forms/SubmissionForm";
import { HollowButton, HollowButtonContainer } from "./Hollow";
import { useApiContract, useMoralis, useWeb3Contract, useWeb3ExecuteFunction } from "react-moralis";
import { CuratorABI, CuratorAddress } from "../solidity/utils/Curator";
import Moralis from "moralis-v1";

const submissionFlowOpen = atom<boolean>(false);
export const useSubmissionFlowOpen = () => useAtom(submissionFlowOpen);

export const SubmissionFlow: FC = (props) => {
  const { account, isWeb3Enabled, enableWeb3, authenticate } = useMoralis();
  const { fetch: runContractFunction, data, error, isLoading, isFetching, } = useWeb3ExecuteFunction();
  const queryClient = useQueryClient();

  const [page, setPage] = useState<number>(0);
  const [fileSelected, setFileSelected] = useState<File>();

  const [open] = useSubmissionFlowOpen();
  useEffect(() => {
    if (!open) setPage(0);
  }, [open]);

  const [loading, setLoading] = useState<boolean>(false);
  const profile = useProfile(account);

  const onSubmit = async (submission: Submission) => {
    setLoading(true);

    console.log(submission);

    try {
      console.log(isWeb3Enabled);
      if (!isWeb3Enabled) {
        throw "Web3 is not enabled";
      }
      if (fileSelected) {
        submission.mediaFormat = fileSelected.type;
        submission.mediaURI = await uploadFiles({
          acceptedFile: fileSelected,
        });
      }

      console.log('Reaches here?');

      await Moralis.enableWeb3();

      const options = {
        abi: CuratorABI,
        contractAddress: CuratorAddress,
        functionName: "Submit",
        params: {
          ipfsURI: 'hello',
          _isArtistSubmission: false, // Must be string
        },
      }

      console.log(options);

      await runContractFunction({
        params: options,
        onError: (err) => {
          console.error(err);
        },
        onSuccess: (res) => {
          console.log(res);
        },
      });

      console.log('contract result', error, data);
      // TEST: gotta see if this works

      const result = (await submit(submission, account)) as Submission;

      console.log('Reaches here2?', result);

      setPage(1);
      queryClient.invalidateQueries("submissions");
      await revalidate(profile?.data?.username, result.id);
    } catch (e) {
      toast.error(e);
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex flex-col w-full sm:mx-8 justify-center sm:py-16 pt-4">
      <h1 className="font-extrabold	text-4xl underline underline-offset-16 text-center">
        Submit
      </h1>
      <div className="h-8" />
      {page === 0 && (
        <SubmissionForm
          metamaskLoading={loading}
          onSubmit={onSubmit}
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
