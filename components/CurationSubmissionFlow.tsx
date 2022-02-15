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

export const CurationSubmissionFlow = (props) => {
  const isCurator = useIsCurator();
  const { account } = useWeb3React();

  const [submissionData, setSubmissionData] = useSubmissionData();

  const [page, setPage] = useState<number>(0);
  const [txnHash, setTxnHash] = useState<string>("0x0");
  const [loading, setLoading] = useState<boolean>(false);

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
          console.log("created");
          console.log(res);
        }

        if (res.event === "EditionMinted") {
          console.log("minted");
          console.log(res);
        }
      });
    }

    return () => {
      phloteContract?.removeAllListeners();
    };
  }, [phloteContract]);

  const submitCuration = async () => {
    setLoading(true);
    const { tokenURI } = await nextApiRequest("store-nft-metadata");

    try {
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
      setTxnHash(res.hash);
      setPage(1);
    } catch {
      console.error("user cancelled transaction");
    }
    setLoading(false);
  };

  return (
    <div className="flex flex-col w-full mx-8">
      <div className="h-8" />
      <h1 className="font-extrabold	text-4xl underline underline-offset-8 text-center">
        Submit
      </h1>
      <div className="h-8" />
      {page === 0 && (
        <MetadataForm
          data={submissionData}
          setData={setSubmissionData}
          metamaskLoading={loading}
          onSubmit={submitCuration}
        />
      )}
      {page === 1 && (
        <div className="flex flex-col items-center">
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
          <div className="h-8" />
          <HollowButtonContainer className="w-1/2" onClick={() => setPage(0)}>
            <HollowButton>Submit Another</HollowButton>
          </HollowButtonContainer>
        </div>
      )}
    </div>
  );
};

const MetadataForm = ({ data, setData, metamaskLoading, onSubmit }) => {
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
      <HollowInputContainer type="form">
        <HollowInput
          type="text"
          placeholder="NFT URL"
          value={nftURL}
          onChange={({ target: { value } }) => setFormField({ nftURL: value })}
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer
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
          <HollowInputContainer style={{ borderRadius: "60px" }}>
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
      <HollowInputContainer type="form">
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
      <HollowInputContainer type="form">
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
      <HollowInputContainer type="form">
        <HollowInput
          type="text"
          placeholder="Marketplace"
          value={marketplace}
          onChange={({ target: { value } }) => setFormField({ nftURL: value })}
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer type="form">
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

      <HollowTagsInput tags={tags} setTags={(tags) => setFormField({ tags })} />
      <div className="h-3" />

      <div className="flex">
        <div className="flex-grow" />

        <HollowButtonContainer className="w-32">
          <HollowButton disabled={metamaskLoading} onClick={onSubmit}>
            {" "}
            {metamaskLoading ? "Waiting for Wallet..." : "Submit"}
          </HollowButton>
        </HollowButtonContainer>
      </div>
      <div className="h-3" />
    </>
  );
};
