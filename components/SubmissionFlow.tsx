import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import Image from "next/image";
import React, { useState } from "react";
import { useQuery, useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { uploadToIPFS } from "../controllers/ipfs";
import { revalidate } from "../controllers/revalidate";
import { useCurator } from "../hooks/web3/useCurator";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetSubmissionByIdDocument,
  GetSubmissionByIdQuery,
  Submission,
} from "../lib/graphql/generated";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { SubmissionForm } from "./Forms/SubmissionForm";
import { HollowButton, HollowButtonContainer } from "./Hollow";

const submissionFlowOpen = atom<boolean>(false);
export const useSubmissionFlowOpen = () => useAtom(submissionFlowOpen);

export const SubmissionFlow: React.FC = (props) => {
  const { account, library } = useWeb3React<Web3Provider>();
  const curator = useCurator();
  const queryClient = useQueryClient();
  // console.log(library.waitForTransaction);

  const [page, setPage] = useState<number>(0);
  const profile = useProfile(account);

  const [loadingMessage, setLoadingMessage] = useState<string>();
  const [txnHash, setTxnHash] = useState<string>();
  const [submissionAddress, setSubmissionAddress] = useState<string>(null);
  const submissionComplete = useWaitForSubmission(submissionAddress);

  const [open] = useSubmissionFlowOpen();

  React.useEffect(() => {
    if (!open && !loadingMessage) {
      // if user closes and we're not waiting for anything, clear all
      setPage(0);
      setTxnHash(null);
    }
  }, [open, loadingMessage]);

  React.useEffect(() => {
    // if user goes back to submit page, clear txn hash
    if (page === 0) setTxnHash(null);
  }, [page]);

  React.useEffect(() => {
    // if we have found the submission in our Db, update submissions everywhere
    if (submissionComplete) {
      const updateSubmissions = async () => {
        await queryClient.invalidateQueries(["submissions"]);
        await queryClient.invalidateQueries(["submission-search"]);
        await revalidate(profile?.data?.username, submissionAddress);
      };
      //submission made it to database
      updateSubmissions();
    }
  }, [
    profile?.data?.username,
    queryClient,
    submissionAddress,
    submissionComplete,
  ]);

  const onSubmit = async (submission: Submission) => {
    setLoadingMessage("Waiting for Wallet...");
    try {
      // upload to IPFS
      const result = await uploadToIPFS(submission, account);
      if (!result.uri) throw "IPFS URI was falsy";

      // Submit function in smart contract
      const txn = await curator.submit(result.uri);

      setTxnHash(txn.hash);
      setLoadingMessage("Transaction Pending...");

      // Wait for transaction
      const receipt = await txn.wait();
      const submissionAddress = receipt.events.find(
        (event) => event.event === "Submit"
      ).args["hotdrop"];

      setPage(1);
      // will trigger
      setSubmissionAddress(submissionAddress);
    } catch (e) {
      toast.error(e);
      console.error(e);
    } finally {
      setLoadingMessage(null);
    }
  };

  return (
    <div className="flex flex-col text-center w-full sm:mx-8 justify-center sm:py-16 pt-4">
      <h1 className="font-extrabold	text-4xl underline underline-offset-16 text-center">
        Submit
      </h1>
      <div className="h-8" />
      {page === 0 && (
        <SubmissionForm loadingMessage={loadingMessage} onSubmit={onSubmit} />
      )}
      {page === 1 && (
        <div className="flex flex-col items-center text-sm my-8 gap-8">
          <p>Congratulations! Your submission has been added</p>

          <HollowButtonContainer className="w-1/2" onClick={() => setPage(0)}>
            <HollowButton>Submit Another</HollowButton>
          </HollowButtonContainer>
        </div>
      )}

      {txnHash && (
        <div className="w-full flex justify-center">
          <a
            className="underline flex"
            rel="noreferrer"
            target="_blank"
            href={`https://mumbai.polygonscan.com/tx/${txnHash}`}
          >
            <p>View Transaction</p>
            <div className="w-1" />
            <Image
              src="/arrow.svg"
              className="ml-4"
              alt={"link"}
              height={12}
              width={12}
            />
          </a>
        </div>
      )}
    </div>
  );
};

const useWaitForSubmission = (submissionAddress: string | null) => {
  const client = initializeApollo();
  const [submissionFound, setSubmissionFound] = useState<boolean>(false);
  const pollSubmission = useQuery(
    ["submission", submissionAddress],
    async () => {
      const res = await client.query<GetSubmissionByIdQuery>({
        query: GetSubmissionByIdDocument,
        variables: { id: submissionAddress.toLowerCase() },
        fetchPolicy: "network-only",
      });

      return res.data.submission;
    },
    {
      refetchInterval: 1000,
      refetchIntervalInBackground: true,
      enabled: !!submissionAddress && !submissionFound,
    }
  );

  React.useEffect(() => {
    if (pollSubmission.data) {
      setSubmissionFound(true);
    }
  }, [pollSubmission.data]);

  return submissionFound;
};
