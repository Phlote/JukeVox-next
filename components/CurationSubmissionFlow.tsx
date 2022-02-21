import { useIsCurator } from "../hooks/useIsCurator";
import {
  HollowInputContainer,
  HollowInput,
  HollowButtonContainer,
  HollowButton,
} from "./Hollow";
import React, { useState } from "react";
import { usePhlote } from "../hooks/usePhlote";
import { HollowTagsInput } from "./Hollow/HollowTagsInput";
import { atom, useAtom } from "jotai";
import { useWeb3React } from "@web3-react/core";
import { nextApiRequest } from "../util";
import { DropdownList } from "./DropdownList";
import Image from "next/image";
import {
  Curation,
  CurationSubmissionForm,
} from "./Forms/CurationSubmissionForm";
import { NFT_MINT_CONTRACT_RINKEBY, NULL_WALLET } from "../contracts/addresses";
import { useUserCurations } from "../pages/myarchive";

export const CurationSubmissionFlow = (props) => {
  const { account } = useWeb3React();

  const [page, setPage] = useState<number>(0);
  const [txnHash, setTxnHash] = useState<string>("0x0");
  const [nftMintId, setNFTMintId] = useState<number | "Loading">("Loading");
  const [loading, setLoading] = useState<boolean>(false);
  const [, setCurations] = useUserCurations();

  const phloteContract = usePhlote();

  React.useEffect(() => {
    if (phloteContract) {
      phloteContract.on("*", (res) => {
        console.log(res);
        if (res.event === "EditionCreated") {
          console.log("created");
          console.log(res);
        }

        if (res.event === "EditionMinted") {
          console.log("minted");
          console.log(res);
          console.log(res.args["tokenId"].toNumber());
          setNFTMintId(res.args["tokenId"].toNumber());
        }
      });
    }

    return () => {
      phloteContract?.removeAllListeners();
    };
  }, [phloteContract]);

  const submitCuration = async (curationData: Curation) => {
    const {
      mediaType,
      artistName,
      artistWallet,
      mediaTitle,
      mediaURI,
      marketplace,
      tags,
    } = curationData;

    let artistWalletToSubmit =
      artistWallet && artistWallet !== "" ? artistWallet : NULL_WALLET;

    console.log("submit: ", curationData);

    setLoading(true);
    try {
      const { tokenURI } = await nextApiRequest(
        "store-nft",
        "POST",
        curationData
      );

      console.log(artistWalletToSubmit);

      const res = await phloteContract.submitPost(
        account,
        mediaURI,
        marketplace,
        tags ?? [],
        artistName,
        artistWalletToSubmit,
        mediaType,
        mediaTitle,
        tokenURI
      );
      console.log(res);
      setTxnHash(res.hash);
      setPage(1);
      setCurations((curations) => [
        { ...curationData, transactionPending: true },
        ...curations,
      ]);
    } catch (e) {
      console.error(e);
    }
    setLoading(false);
  };

  return (
    <div className="flex flex-col w-full mx-8 ">
      <div className="h-8" />
      <h1 className="font-extrabold	text-4xl underline underline-offset-16 text-center">
        Submit
      </h1>
      <div className="h-8" />
      {page === 0 && (
        <CurationSubmissionForm
          metamaskLoading={loading}
          onSubmit={submitCuration}
        />
      )}
      {page === 1 && (
        <div className="flex flex-col items-center text-sm mt-8">
          <p>Congratulations! Your submission has been added</p>
          <div className="h-8" />
          <a
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
          </a>

          <div className="h-8" />
          <HollowButtonContainer className="w-1/2" onClick={() => setPage(0)}>
            <HollowButton>Submit Another</HollowButton>
          </HollowButtonContainer>
        </div>
      )}
    </div>
  );
};
