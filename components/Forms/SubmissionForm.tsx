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
import { FileUpload } from "../FileUpload";
import { Toggle } from "../Dropdowns/Toggle";
import { useMoralis } from "react-moralis";

export const SubmissionForm = ({ metamaskLoading, onSubmit, fileSelected, setFileSelected }) => {
  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const [artist, setArtist] = useState(false);
  const { form, handleSubmit, valid } = useForm({
    onSubmit,
    validate: validateSubmission,
  });

  const mediaURI = useField("mediaURI", form);
  const mediaType = useField("mediaType", form);
  const artistName = useField("artistName", form);
  const mediaTitle = useField("mediaTitle", form);
  const playlist = useField("playlist", form);
  const tags = useField("tags", form);

  const { account } = useMoralis();

  return (
    <div className="grid grid-cols-1 gap-3 md:my-8">
      {/*Toggle*/}

      <span className="flex justify-between">
        <span>{mediaType.input.value === "File" ? "Artist" : "Curator"}</span>
        <Toggle {...mediaType.input} fields={['Link', 'File']} setURI={mediaURI.input.onChange}
                setFileSelected={setFileSelected} />
      </span>

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

      <HollowInputContainer
        onClick={() => setDropdownOpen(!dropdownOpen)}
        type="form"
      >
        <div className="flex flex-row w-full">
          <HollowInput
            value={playlist.input.value}
            className="flex-grow"
            type="text"
            placeholder="Playlist"
            readOnly
          />
          {(playlist.meta.touched || playlist.meta.visited) &&
            playlist.meta.error && (
              <span className="text-red-600 ml-2">{playlist.meta.error}</span>
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
            {...playlist.input}
            close={() => setDropdownOpen(false)}
            fields={["Secret Radio"]}
            closeOnSelect
            borders
          />
        </HollowInputContainer>
      )}

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
            {metamaskLoading ? metamaskLoading : "Mint"}
          </HollowButton>
          <Image src="/favicon.svg" height={16} width={16} alt={"Gem"} />
        </HollowButtonContainer>
      </div>
    </div>
  );
};
