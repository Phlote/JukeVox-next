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

type MediaType = "Music" | "Text" | "Audio" | "Video";
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

export const CurationSubmissionFlow = (props) => {
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
      <div className="flex flex-col  w-full mx-8">
        <div className="h-8" />
        <h1 className="font-extrabold	text-4xl underline underline-offset-8 text-center">
          Submit
        </h1>
        <div className="h-8" />
        <MetadataForm
          data={submissionData}
          setData={setSubmissionData}
          onSubmit={() => setPage(page + 1)}
        />
      </div>
    );
  }
};

const MetadataForm = ({ data, setData, onSubmit }) => {
  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);

  const {
    mediaType,
    artistName,
    artistWallet,
    mediaTitle,
    nftURL,
    marketplace,
    tags,
  } = data;

  const setFormField = (update: Partial<CurationSubmission>) => {
    setData((current) => {
      return { ...current, ...update };
    });
  };

  return (
    <>
      <HollowInputContainer
        backgroundColor="rgba(101, 101, 101, 0.17)"
        type="form"
      >
        <HollowInput
          type="text"
          placeholder="NFT URL"
          value={nftURL}
          onChange={({ target: { value } }) => setFormField({ nftURL: value })}
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer
        backgroundColor="rgba(101, 101, 101, 0.17)"
        onClick={() => setDropdownOpen(!dropdownOpen)}
        type="form"
      >
        <div className="flex flex-row w-full">
          <HollowInput
            className="flex-grow"
            type="text"
            placeholder="Media Type"
          />
          <Image
            className={dropdownOpen ? "-rotate-90" : "rotate-90"}
            src={"/chevron.svg"}
            alt="dropdown"
            height={16}
            width={16}
          />
        </div>
      </HollowInputContainer>
      {dropdownOpen && (
        <>
          <div className="h-4" />{" "}
          <HollowInputContainer
            backgroundColor="rgba(101, 101, 101, 0.17)"
            style={{ borderRadius: "60px" }}
          >
            <DropdownList
              fields={["Music", "Text", "Audio", "Video"]}
              selectedField={mediaType}
              onSelect={(field) =>
                setFormField({ mediaType: field as MediaType })
              }
            />
          </HollowInputContainer>
          <div className="h-4" />{" "}
        </>
      )}
      <div className="h-3" />
      <HollowInputContainer
        backgroundColor="rgba(101, 101, 101, 0.17)"
        type="form"
      >
        <HollowInput
          type="text"
          placeholder="Artist Name"
          value={artistName}
          onChange={({ target: { value } }) =>
            setFormField({ artistName: value })
          }
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer
        backgroundColor="rgba(101, 101, 101, 0.17)"
        type="form"
      >
        <HollowInput
          type="text"
          placeholder="Title"
          value={mediaTitle}
          onChange={({ target: { value } }) =>
            setFormField({ mediaTitle: value })
          }
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer
        backgroundColor="rgba(101, 101, 101, 0.17)"
        type="form"
      >
        <HollowInput
          type="text"
          placeholder="Marketplace"
          value={marketplace}
          onChange={({ target: { value } }) => setFormField({ nftURL: value })}
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer
        backgroundColor="rgba(101, 101, 101, 0.17)"
        type="form"
      >
        <HollowInput
          type="text"
          placeholder="Artist Wallet Address"
          value={artistWallet}
          onChange={({ target: { value } }) =>
            setFormField({ marketplace: value })
          }
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer
        backgroundColor="rgba(101, 101, 101, 0.17)"
        type="form"
      >
        <HollowTagsInput
          tags={tags}
          setTags={(tags) => setFormField({ tags })}
        />
      </HollowInputContainer>
      <div className="h-3" />

      <div className="flex">
        <div className="flex-grow" />

        <HollowButtonContainer className="w-16">
          <HollowButton onClick={onSubmit}>Submit</HollowButton>
        </HollowButtonContainer>
      </div>
      <div className="h-3" />
    </>
  );
};
