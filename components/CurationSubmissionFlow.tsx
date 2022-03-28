import { useWeb3React } from "@web3-react/core";
import React, { useState } from "react";
import { useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { usePhlote } from "../hooks/web3/usePhlote";
import { Curation } from "../types/curations";
import { nextApiRequest } from "../utils";
import { supabase } from "../utils/supabase";
import { verifyUser } from "../utils/web3";
import { CurationSubmissionForm } from "./Forms/CurationSubmissionForm";
import { HollowButton, HollowButtonContainer } from "./Hollow";

export const CurationSubmissionFlow = (props) => {
  const { account, library } = useWeb3React();
  const queryClient = useQueryClient();

  const [page, setPage] = useState<number>(0);

  const [loading, setLoading] = useState<boolean>(false);

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
        }
      });
    }

    return () => {
      phloteContract?.removeAllListeners();
    };
  }, [phloteContract]);

  const submitCuration = async (curation: Curation) => {
    setLoading(true);
    try {
      const authenticated = await verifyUser(account, library);

      if (!authenticated) {
        toast.error("Authentication failed");
        return;
      }

      const { cid } = await nextApiRequest(
        "store-submission-on-ipfs",
        "POST",
        curation
      );

      const { data, error } = await supabase
        .from("submissions")
        .insert([{ curatorWallet: account, cid, ...curation }]);

      if (error) throw error;

      setPage(1);
      queryClient.invalidateQueries("submissions");
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
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

          <div className="h-8" />
          <HollowButtonContainer className="w-1/2" onClick={() => setPage(0)}>
            <HollowButton>Submit Another</HollowButton>
          </HollowButtonContainer>
        </div>
      )}
    </div>
  );
};
