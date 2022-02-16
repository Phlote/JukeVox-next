import { useState } from "react";
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
  tags: string[];
}

// const submissionAtom = atom<CurationSubmission>({
//   mediaType: "" as MediaType,
//   artistName: "",
//   artistWallet: "",
//   mediaTitle: "",
//   nftURL: "",
//   marketplace: "",
//   tags: [],
// });
// export const useSubmissionData = () => useAtom(submissionAtom);

export const CurationSubmissionForm = ({
  //   data,
  //   setData,
  metamaskLoading,
  onSubmit,
}) => {
  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const { form, handleSubmit, values, pristine, submitting } = useForm({
    onSubmit,
    validate: validateCurationSubmission,
  });

  //   const {
  //     mediaType,
  //     artistName,
  //     artistWallet,
  //     mediaTitle,
  //     nftURL,
  //     marketplace,
  //     tags,
  //   } = data;

  const nftURL = useField("nftURL", form);
  const mediaType = useField("mediaType", form);
  const artistName = useField("artistName", form);

  //   const setFormField = (update: Partial<CurationSubmission>) => {
  //     setData((current) => {
  //       return { ...current, ...update };
  //     });
  //   };

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
            className="flex-grow"
            type="text"
            placeholder="Media Type"
          />
          {mediaType.meta.visited && mediaType.meta.error && (
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
      {/*
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
          onChange={({ target: { value } }) =>
            setFormField({ marketplace: value })
          }
        />
      </HollowInputContainer>
      <div className="h-3" />
      <HollowInputContainer type="form">
        <HollowInput
          type="text"
          placeholder="Artist Wallet Address"
          value={artistWallet}
          onChange={({ target: { value } }) =>
            setFormField({ artistWallet: value })
          }
        />
      </HollowInputContainer>
      <div className="h-3" />

      <HollowTagsInput tags={tags} setTags={(tags) => setFormField({ tags })} />
      <div className="h-3" />
*/}
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
