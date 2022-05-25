import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import Image from "next/image";
import React, { useState } from "react";
import { useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { uploadToIPFS } from "../controllers/ipfs";
import { revalidate } from "../controllers/revalidate";
import { useCurator } from "../hooks/web3/useCurator";
import { Submission } from "../lib/graphql/generated";
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

  const [open] = useSubmissionFlowOpen();
  React.useEffect(() => {
    if (!open && !loadingMessage) {
      setPage(0);
      setTxnHash(null);
    }
  }, [open, loadingMessage]);

  const onSubmit = async (submission: Submission) => {
    setLoadingMessage("Waiting for Wallet...");
    try {
      // upload to IPFS
      const result = await uploadToIPFS(submission, account);
      if (!result.uri) throw "IPFS URI was falsy";

      const txn = await curator.submit(result.uri);

      setTxnHash(txn.hash);
      setLoadingMessage("Transaction pending...");

      const receipt = await txn.wait();

      const submissionAddress = receipt.events.find(
        (event) => event.event === "Submit"
      ).args["hotdrop"];

      await revalidate(profile?.data?.username ?? account, submissionAddress);
      queryClient.invalidateQueries(["submissions", "submission-search"]);
      setPage(1);
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
      {/* {txnHash && ( */}
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
      {/* )} */}
    </div>
  );
};
