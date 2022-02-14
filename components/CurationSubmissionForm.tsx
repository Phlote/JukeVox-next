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

  // phloteContract.on("*", (args) => {
  //   console.log(args);
  // });

  const submitNFT = async () => {
    // submit to IPFS,

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

  // if (!isCurator) return null;

  if (page === 0) {
    return (
      <div className="flex flex-col text-center w-10/12">
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
            placeholder="URL of NFT"
            value={nftURL}
            onChange={({ target: { value } }) =>
              setFormField({ nftURL: value })
            }
          />
        </HollowInputContainer>

        <button onClick={() => setPage((page) => page + 1)}>Next</button>
      </div>
    );
  }

  if (page === 1) {
    return (
      <div className="flex flex-col text-center w-10/12">
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
            placeholder="Song Title"
            value={mediaTitle}
            onChange={({ target: { value } }) =>
              setFormField({ mediaTitle: value })
            }
          />
        </HollowInputContainer>
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Marketplace Name"
            value={nftURL}
            onChange={({ target: { value } }) =>
              setFormField({ nftURL: value })
            }
          />
        </HollowInputContainer>
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Marketplace (i.e. OpenSea, Zora)"
            value={marketplace}
            onChange={({ target: { value } }) =>
              setFormField({ marketplace: value })
            }
          />
        </HollowInputContainer>

        {/* <button onClick={() => setPage((page) => page + 1)}>Next</button>
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowTagsInput
            tags={tags}
            setTags={(tags) => setFormField({ tags })}
          />
        </HollowInputContainer> */}
      </div>
    );
  }
};
