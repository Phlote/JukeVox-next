import { atom, useAtom } from "jotai";
import React, { FC, useEffect, useState } from "react";
import { useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { revalidate } from "../controllers/revalidate";
import { submit } from "../controllers/submissions";
import { shortenHex, verifyUser } from "../utils/web3";
import { ArtistSubmission, ContractRes, CuratorSubmission } from "../types";
import { uploadFiles } from "./FileUpload";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { SubmissionForm } from "./Forms/SubmissionForm";
import { HollowButton, HollowButtonContainer } from "./Hollow";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import { CuratorABI, CuratorAddress } from "../solidity/utils/Curator";
import { sub } from "mcl-wasm";

const submissionFlowOpen = atom<boolean>(false);
export const useSubmissionFlowOpen = () => useAtom(submissionFlowOpen);

export const SubmissionFlow: FC = (props) => {
  const { account, isWeb3Enabled } = useMoralis();
  const { fetch: runContractFunction, data, error, isLoading, isFetching, } = useWeb3ExecuteFunction();
  const queryClient = useQueryClient();

  const [page, setPage] = useState<number>(0);
  const [fileSelected, setFileSelected] = useState<File>();
  const [contractRes, setContractRes] = useState<ContractRes>({});

  const [open] = useSubmissionFlowOpen();
  useEffect(() => {
    if (!open) setPage(0);
  }, [open]);

  useEffect(() => {
    if (isFetching) setLoading('Signing Contract...');
    if (isLoading) setLoading('User action required');
  }, [isLoading, isFetching]);

  // isLoading: user action required - (metamask popup open)
  // isFetching: signing contract and getting results from it

  const [loading, setLoading] = useState<boolean | string>(false);
  const profile = useProfile(account);

  const onSubmit = async (submission: ArtistSubmission | CuratorSubmission) => {
    setLoading("Interface with wallet");

    try {
      if (!isWeb3Enabled) {
        throw "Web3 is not enabled";
      }
      const isFile = submission.mediaType === 'File';
      submission.isArtist = isFile;
      if (isFile && fileSelected && submission.isArtist) {
        submission.mediaFormat = fileSelected.type;
        submission.mediaURI = await uploadFiles({
          acceptedFile: fileSelected,
        });
      }

      // https://ipfs.moralis.io:2053/ipfs/QmXHN1h5GFshiiUm2Wx7gjZjFxxyFUfU21TDwzJ1fQETSY

      const options = {
        abi: CuratorABI,
        contractAddress: CuratorAddress,
        functionName: "submit",
        params: {
          _ipfsURI: submission.mediaURI,
          _isArtistSubmission: isFile,
        },
      }

      const submitTransaction = await runContractFunction({
        params: options,
        onError: (err) => {
          setContractRes(err);
          throw err;
        },
        onSuccess: (res) => {
          console.info(res);
        },
      });

      // @ts-ignore
      const contractResult = await submitTransaction.wait();

      submission.hotdropAddress = contractResult.events[0].address;

      console.log('contract result', contractResult);

      console.log(submission);

      const result =
        submission.isArtist ?
          (await submit(submission, account, submission.mediaType)) as ArtistSubmission
          :
          (await submit(submission, account, submission.mediaType)) as CuratorSubmission;

      console.log('DB', result);

      // TODO: Throw error when result throws error instead of moving forward and showing success page.

      setPage(1);
      await queryClient.invalidateQueries("submissions");
      await revalidate(account, result.submissionID);
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
          {
            contractRes.hash && ( // Is every submission an nft or only files?
              <div>
                <p className='w-full text-center'>Congratulations! Your submission has been added</p>
                <p className='w-full text-center'>Check it out on Polygon!</p>
                <br />
                <p className='w-full text-center'>
                  <a rel='noreferrer' target='_blank' href={`https://mumbai.polygonscan.com/tx/${contractRes.hash}`}
                     className='underline w-full text-center'>{shortenHex(contractRes.hash)}</a>
                  {/*TESTNET TRANSACTION URL, must change to https://mumbai.polygonscan.com/address/ when out of testnet*/}
                </p>
              </div>
            )
          }
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
