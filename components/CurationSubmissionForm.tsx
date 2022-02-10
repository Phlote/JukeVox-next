import { useIsCurator } from "../hooks/useIsCurator";
import { HollowInputContainer, HollowInput } from "./Hollow";
import React, { useState } from "react";
import { usePhlote } from "../hooks/usePhlote";
import { HollowTagsInput } from "./Hollow/HollowTagsInput";
import { atom, useAtom } from "jotai";

type MediaType = "music" | "text" | "audio" | "video";
interface CurationSubmission {
  mediaType: MediaType;
  artistName: string;
  artistWallet?: string;
  mediaTitle: string;
  nftURL: string;
  marketplace: string;
  tags: string[];
}

const submissionAtom = atom<CurationSubmission>({} as CurationSubmission);
const useSubmissionData = () => useAtom(submissionAtom);

const submissionPageAtom = atom<number>(0);
const useSubmissionPage = () => useAtom(submissionPageAtom);

export const CurationSubmissionForm = (props) => {
  const isCurator = useIsCurator();

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

  const submitNFT = async () => {
    const res = await phloteContract.setSong(
      mediaTitle,
      artistName,
      nftURL,
      10
    );
    console.log(res.hash);
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
            placeholder="Title"
            value={nftURL}
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
              setFormField({ marketplace: value })
            }
          />
        </HollowInputContainer>
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Artist Wallet Address (optional)"
            value={nftURL}
            onChange={({ target: { value } }) =>
              setFormField({ artistWallet: value })
            }
          />
        </HollowInputContainer>

        <button onClick={() => setPage((page) => page + 1)}>Next</button>
      </div>
    );
  }

  // return (
  //   <div className="flex flex-col text-center w-10/12">
  //     <h1 className="mb-1 text-4xl underline-offset-8	underline">Submit</h1>
  //     <div className="h-16"></div>
  //     <div className="grid grid-cols-2 gap-4">
  //       {/* todo dropdown */}
  //       <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
  //         <HollowInput
  //           type="text"
  //           placeholder="Media Type"
  //           value={mediaType}
  //           onChange={({ target: { value } }) => setMediaType(value)}
  //         />
  //       </HollowInputContainer>

  //       <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
  //         <HollowInput
  //           type="text"
  //           placeholder="Artist Name"
  //           value={artistName}
  //           onChange={({ target: { value } }) => setArtistName(value)}
  //         />
  //       </HollowInputContainer>

  //       <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
  //         <HollowInput
  //           type="text"
  //           placeholder="Artist Wallet Address"
  //           value={artistWallet}
  //           onChange={({ target: { value } }) => setArtistWallet(value)}
  //         />
  //       </HollowInputContainer>

  //       <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
  //         <HollowInput
  //           type="text"
  //           placeholder="Song Title"
  //           value={songTitle}
  //           onChange={({ target: { value } }) => setSongTitle(value)}
  //         />
  //       </HollowInputContainer>

  //       <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
  //         <HollowInput
  //           type="text"
  //           placeholder="URL of NFT"
  //           value={nftURL}
  //           onChange={({ target: { value } }) => setNFTURL(value)}
  //         />
  //       </HollowInputContainer>

  //       <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
  //         <HollowInput
  //           type="text"
  //           placeholder="Marketplace (i.e. OpenSea, Zora)"
  //           value={marketplace}
  //           onChange={({ target: { value } }) => setMarketplace(value)}
  //         />
  //       </HollowInputContainer>

  //       <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
  //         <HollowTagsInput tags={tags} setTags={setTags} />
  //       </HollowInputContainer>
  //     </div>
  //     <button onClick={submitNFT}>Submit</button>
  //   </div>
  // );
};
