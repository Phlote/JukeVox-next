import React, { useState } from "react";
import { DropdownList } from "../DropdownList";
import {
  HollowInputContainer,
  HollowInput,
  HollowButtonContainer,
  HollowButton,
} from "../Hollow";
import { HollowTagsInput } from "../Hollow/HollowTagsInput";
import Image from "next/image";
import { atom, useAtom } from "jotai";
import { useForm, useField } from "react-final-form-hooks";
import { validateCurationSubmission } from "./validators";

type MediaType = "Music" | "Text" | "Audio" | "Video";
export interface CurationSubmission {
  mediaType: MediaType;
  artistName: string;
  artistWallet?: string;
  mediaTitle: string;
  nftURL: string;
  marketplace: string;
  tags?: string[];
}

export const CurationSubmissionForm = ({ metamaskLoading, onSubmit }) => {
  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const { form, handleSubmit, values, pristine, submitting } = useForm({
    onSubmit,
    validate: validateCurationSubmission,
  });

  const nftURL = useField("nftURL", form);
  const mediaType = useField("mediaType", form);
  const artistName = useField("artistName", form);
  const mediaTitle = useField("mediaTitle", form);
  const marketplace = useField("marketplace", form);
  const artistWallet = useField("artistWallet", form);
  const tags = useField("tags", form);

  return (
    <form onSubmit={handleSubmit}>
      <HollowInputContainer type="form">
        <HollowInput
          {...nftURL.input}
          type="text"
          placeholder="NFT URL"
        ></HollowInput>
        {nftURL.meta.touched && nftURL.meta.error && (
          <span className="text-red-600">{nftURL.meta.error}</span>
        )}
      </HollowInputContainer>
      <div className="h-3" />

      <HollowInputContainer
        onClick={() => setDropdownOpen(!dropdownOpen)}
        type="form"
      >
        <div className="flex flex-row w-full">
          <HollowInput
            value={mediaType.input.value}
            className="flex-grow"
            type="text"
            placeholder="Media Type"
          />
          {(mediaType.meta.touched || mediaType.meta.visited) &&
            mediaType.meta.error && (
              <span className="text-red-600">{mediaType.meta.error}</span>
            )}
          <div className="w-2" />
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
              {...mediaType.input}
              close={() => setDropdownOpen(false)}
              fields={["Music", "Text", "Audio", "Video"]}
            />
          </HollowInputContainer>
          <div className="h-3" />{" "}
        </>
      )}

      <div className="h-3" />
      <HollowInputContainer type="form">
        <HollowInput
          {...artistName.input}
          type="text"
          placeholder="Artist Name"
        />
        {artistName.meta.touched && artistName.meta.error && (
          <span className="text-red-600">{artistName.meta.error}</span>
        )}
      </HollowInputContainer>
      <div className="h-3" />

      <HollowInputContainer type="form">
        <HollowInput {...mediaTitle.input} type="text" placeholder="Title" />
        {mediaTitle.meta.touched && mediaTitle.meta.error && (
          <span className="text-red-600">{mediaTitle.meta.error}</span>
        )}
      </HollowInputContainer>
      <div className="h-3" />

      <HollowInputContainer type="form">
        <HollowInput
          {...marketplace.input}
          type="text"
          placeholder="Marketplace"
        />
        {marketplace.meta.touched && marketplace.meta.error && (
          <span className="text-red-600">{marketplace.meta.error}</span>
        )}
      </HollowInputContainer>
      <div className="h-3" />

      <HollowInputContainer type="form">
        <HollowInput
          {...artistWallet.input}
          type="text"
          placeholder="Artist Wallet Address (Optional)"
        />
      </HollowInputContainer>
      <div className="h-3" />

      <HollowTagsInput {...tags.input} />
      <div className="h-3" />

      <div className="flex">
        <div className="flex-grow" />

        <HollowButtonContainer className="w-32">
          <HollowButton disabled={metamaskLoading}>
            {metamaskLoading ? "Waiting for Wallet..." : "Submit"}
          </HollowButton>
        </HollowButtonContainer>
      </div>
      <div className="h-3" />
    </form>
  );
};