import Image from "next/image";
import React, { useState } from "react";
import { useField, useForm } from "react-final-form-hooks";
import { DropdownChecklist } from "../Dropdowns/DropdownChecklist";
import {
  HollowButton,
  HollowButtonContainer,
  HollowInput,
  HollowInputContainer,
} from "../Hollow";
import { HollowTagsInput } from "../Hollow/HollowTagsInput";
import { validateSubmission } from "./validators";
import {FileUpload} from "../FileUpload";
import { useMoralis } from "react-moralis";

export const SubmissionForm = ({ metamaskLoading, onSubmit, fileSelected, setFileSelected}) => {
  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const { form, handleSubmit, valid } = useForm({
    onSubmit,
    validate: validateSubmission,
  });

  const mediaURI = useField("mediaURI", form);
  const mediaType = useField("mediaType", form);
  const artistName = useField("artistName", form);
  const mediaTitle = useField("mediaTitle", form);
  const marketplace = useField("marketplace", form);
  const artistWallet = useField("artistWallet", form);
  const tags = useField("tags", form);

  const { account } = useMoralis();

  return (
    <div className="grid grid-cols-1 gap-3 md:my-8">
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
            readOnly
          />
          {(mediaType.meta.touched || mediaType.meta.visited) &&
            mediaType.meta.error && (
              <span className="text-red-600 ml-2">{mediaType.meta.error}</span>
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
        <HollowInputContainer style={{ borderRadius: "60px" }}>
          <DropdownChecklist
            {...mediaType.input}
            close={() => setDropdownOpen(false)}
            fields={["File", "Link"]}
            closeOnSelect
            borders
          />
        </HollowInputContainer>
      )}

      {mediaType.input.value === "File" ? (
            <FileUpload
              wallet={account}
              fileSelected={fileSelected}
              setFileSelected={setFileSelected}
            />
      ) : (
        <HollowInputContainer type="form">
          <HollowInput {...mediaURI.input} type="text" placeholder="Link" />
          {mediaURI.meta.touched && mediaURI.meta.error && (
            <span className="text-red-600 ml-2">{mediaURI.meta.error}</span>
          )}
        </HollowInputContainer>
      )}

      <HollowInputContainer type="form">
        <HollowInput
          {...artistName.input}
          type="text"
          placeholder="Artist Name"
        />
        {artistName.meta.touched && artistName.meta.error && (
          <span className="text-red-600 ml-2">{artistName.meta.error}</span>
        )}
      </HollowInputContainer>

      <HollowInputContainer type="form">
        <HollowInput {...mediaTitle.input} type="text" placeholder="Title" />
        {mediaTitle.meta.touched && mediaTitle.meta.error && (
          <span className="text-red-600 ml-2">{mediaTitle.meta.error}</span>
        )}
      </HollowInputContainer>

      <HollowInputContainer type="form">
        <HollowInput
          {...marketplace.input}
          type="text"
          placeholder="Marketplace/Platform"
        />
        {marketplace.meta.touched && marketplace.meta.error && (
          <span className="text-red-600 ml-2">{marketplace.meta.error}</span>
        )}
      </HollowInputContainer>

      <HollowInputContainer type="form">
        <HollowInput
          {...artistWallet.input}
          type="text"
          placeholder="Artist Wallet Address (Optional)"
        />
        {artistWallet.meta.touched && artistWallet.meta.error && (
          <span className="ml-2 text-red-600">{artistWallet.meta.error}</span>
        )}
      </HollowInputContainer>
      <HollowTagsInput {...tags.input} />
      <div className="flex justify-center items-center">
        <HollowButtonContainer onClick={handleSubmit}>
          <HollowButton
            className="w-18"
            disabled={
              !(metamaskLoading
                ? false
                : (mediaType.input.value === "File" &&
                    valid &&
                    !!fileSelected) ||
                  (mediaType.input.value === "Link" && valid))//TODO: do mediaType checks in the validator file
            }
          >
            {metamaskLoading ? "Waiting for Wallet..." : "Mint"}
          </HollowButton>
          <Image src="/favicon.svg" height={16} width={16} alt={"Gem"} />
        </HollowButtonContainer>
      </div>
    </div>
  );
};
