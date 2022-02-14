import { useIsCurator } from "../hooks/useIsCurator";
import { HollowInputContainer, HollowInput } from "./Hollow";
import React, { useState } from "react";
import { usePhlote } from "../hooks/usePhlote";
import { HollowTagsInput } from "./Hollow/HollowTagsInput";
import { atom, useAtom } from "jotai";
import { useWeb3React } from "@web3-react/core";
import { nextApiRequest } from "../util";

type MediaType = "music" | "text" | "audio" | "video";
export interface CurationSubmission {
  mediaType: MediaType;
  artistName: string;
  artistWallet?: string;
  mediaTitle: string;
  nftURL: string;
  marketplace: string;
  tags: string[];
}

const submissionAtom = atom<CurationSubmission>({
  mediaType: "" as MediaType,
  artistName: "",
  artistWallet: "",
  mediaTitle: "",
  nftURL: "",
  marketplace: "",
  tags: [],
});
const useSubmissionData = () => useAtom(submissionAtom);

const submissionPageAtom = atom<number>(0);
const useSubmissionPage = () => useAtom(submissionPageAtom);

export const CurationSubmissionForm = (props) => {
  const isCurator = useIsCurator();
  const { account } = useWeb3React();

  const [submissionData, setSubmissionData] = useSubmissionData();
  const [page, setPage] = useSubmissionPage();

  const {
    mediaType,
    artistName,
    artistWallet,
    mediaTitle,
    nftURL,
    marketplace,
    tags,
  } = submissionData;

  const setFormField = (update: Partial<CurationSubmission>) => {
    setSubmissionData((current) => {
      return { ...current, ...update };
    });
  };

  const phloteContract = usePhlote();

  React.useEffect(() => {
    if (phloteContract) {
      phloteContract.on("*", (res) => {
        console.log(res);
        if (res.event === "EditionCreated") {
          console.log(res);
        }

        if (res.event === "EditionMinted") {
          console.log(res);
          alert("It has been minted!");
        }
      });
    }

    return () => {
      phloteContract?.removeAllListeners();
    };
  }, [phloteContract]);

  const submitNFT = async () => {
    const { tokenURI } = await nextApiRequest("store-nft-metadata");
    console.log(tokenURI);

    const res = await phloteContract.submitPost(
      account,
      nftURL,
      marketplace,
      tags,
      artistName,
      mediaType,
      mediaTitle,
      tokenURI
    );
    console.log(res);
  };

  if (page === 0) {
    return (
      <div className="text-center mx-auto">
        <h1>Curate</h1>
        <div className="grid grid-cols-1 gap-y-0.5 w-full">
          <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
            <HollowInput
              type="text"
              placeholder="NFT URL"
              value={nftURL}
              onChange={({ target: { value } }) =>
                setFormField({ nftURL: value })
              }
            />
          </HollowInputContainer>
          <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
            <HollowInput
              type="text"
              placeholder="Media Type"
              value={mediaType}
              onChange={({ target: { value } }) =>
                setFormField({ mediaType: value })
              }
            />
          </HollowInputContainer>
          <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
            <HollowInput
              type="text"
              placeholder="Artist Name"
              value={artistName}
              onChange={({ target: { value } }) =>
                setFormField({ artistName: value })
              }
            />
          </HollowInputContainer>
          <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
            <HollowInput
              type="text"
              placeholder="Title"
              value={mediaTitle}
              onChange={({ target: { value } }) =>
                setFormField({ mediaTitle: value })
              }
            />
          </HollowInputContainer>
          <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
            <HollowInput
              type="text"
              placeholder="Marketplace"
              value={marketplace}
              onChange={({ target: { value } }) =>
                setFormField({ nftURL: value })
              }
            />
          </HollowInputContainer>
          <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
            <HollowInput
              type="text"
              placeholder="Artist Wallet Address"
              value={artistWallet}
              onChange={({ target: { value } }) =>
                setFormField({ marketplace: value })
              }
            />
          </HollowInputContainer>
          <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
            <HollowTagsInput
              tags={tags}
              setTags={(tags) => setFormField({ tags })}
            />
          </HollowInputContainer>

          <button onClick={submitNFT}>Submit</button>
        </div>
      </div>
    );
  }
};
