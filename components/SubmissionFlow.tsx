import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import { FC, useEffect, useState } from "react";
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

const submissionFlowOpen = atom<boolean>(false);
export const useSubmissionFlowOpen = () => useAtom(submissionFlowOpen);

export const SubmissionFlow: FC = (props) => {
  const { account, library } = useWeb3React();
  const queryClient = useQueryClient();

  const [page, setPage] = useState<number>(0);
  const [fileSelected, setFileSelected] = useState<File>();
  const [fileURL, setFileURL] = useState<string>(null);
  const [updating, setUpdating] = useState<boolean>();

  const [open] = useSubmissionFlowOpen();
  useEffect(() => {
    if (!open) setPage(0);
  }, [open]);

  const [loading, setLoading] = useState<boolean>(false);
  const profile = useProfile(account);

  const onSubmit = async (submission: Submission) => {
    setLoading(true);
    try {
      const authenticated = await verifyUser(account, library);
      if (!authenticated) {
        throw "Not Authenticated";
      }

      if (!!fileSelected) {
        submission.mediaURI = await uploadFiles({
          acceptedFile: fileSelected,
          wallet: account,
          queryClient,
          fileURL,
          setFileURL,
          updating,
          setUpdating,
        });
      }

      const result = (await submit(submission, account)) as Submission;

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
          updating={updating}
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
