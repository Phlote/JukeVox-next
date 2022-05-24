import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import Image from "next/image";
import React, { useState } from "react";
import { toast } from "react-toastify";
import { uploadToIPFS } from "../controllers/ipfs";
import { useCurator } from "../hooks/web3/useCurator";
import { Submission } from "../lib/graphql/generated";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { SubmissionForm } from "./Forms/SubmissionForm";
import { HollowButton, HollowButtonContainer } from "./Hollow";

const submissionFlowOpen = atom<boolean>(false);
export const useSubmissionFlowOpen = () => useAtom(submissionFlowOpen);

export const SubmissionFlow: React.FC = (props) => {
  const { account } = useWeb3React();
  const curator = useCurator();

  const [page, setPage] = useState<number>(0);
  const profile = useProfile(account);

  const [loading, setLoading] = useState<boolean>(false);
  const [txnHash, setTxnHash] = useState<string>();

  const [open] = useSubmissionFlowOpen();
  React.useEffect(() => {
    if (!open) {
      setPage(0);
      setTxnHash(null);
    }
  }, [open]);

  const onSubmit = async (submission: Submission) => {
    setLoading(true);
    try {
      // const authenticated = await verifyUser(account, library);
      // if (!authenticated) {
      //   throw "Not Authenticated";
      // }
      // const result = (await submit(submission, account)) as Submission;
      // setPage(1);
      // queryClient.invalidateQueries("submissions");
      // await revalidate(profile?.data?.username, result.id);

      // upload to IPFS
      const result = await uploadToIPFS(submission, account);
      if (!result.uri) throw "IPFS URI was falsy";
      // mint an NFT
      const txn = await curator.submit(result.uri);
      console.log(txn);
      setTxnHash(txn.hash);

      setPage(1);
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
        <SubmissionForm metamaskLoading={loading} onSubmit={onSubmit} />
      )}
      {page === 1 && (
        <div className="flex flex-col items-center text-sm mt-8 gap-8">
          <p>Congratulations! Your submission has been added</p>
          <a
            className="underline flex"
            rel="noreferrer"
            target="_blank"
            href={`https://mumbai.polygonscan.com/tx/${txnHash}`}
          >
            View Transaction
            <div className="w-1" />
            <Image src="/arrow.svg" alt={"link"} height={12} width={12} />
          </a>
          {/* <div className="h-4" />
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
