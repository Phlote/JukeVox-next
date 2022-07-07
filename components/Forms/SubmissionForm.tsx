import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import React, { useCallback, useEffect, useState } from "react";
import { DropEvent, FileRejection, useDropzone } from "react-dropzone";
import { useField, useForm } from "react-final-form-hooks";
import { useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { supabase } from "../../lib/supabase";
import { DropdownChecklist } from "../Dropdowns/DropdownChecklist";
import {
  HollowButton,
  HollowButtonContainer,
  HollowInput,
  HollowInputContainer,
} from "../Hollow";
import { HollowTagsInput } from "../Hollow/HollowTagsInput";
import { validateSubmission } from "./validators";

export const SubmissionForm = ({ metamaskLoading, onSubmit }) => {
  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const [fileSelected, setFileSelected] = useState<File>();
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

  const { account } = useWeb3React();

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
          initialFileURL={null}
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
            className="w-16"
            disabled={
              !(metamaskLoading
                ? false
                : (mediaType.input.value === "File" &&
                    valid &&
                    !!fileSelected) ||
                  (mediaType.input.value === "Link" && valid))
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

interface FileUploadProps {
  wallet: string;
  initialFileURL: string;
  fileSelected: File;
  setFileSelected: React.Dispatch<React.SetStateAction<File>>;
}

const FileUpload: React.FC<FileUploadProps> = ({
  wallet,
  initialFileURL,
  fileSelected,
  setFileSelected,
}) => {
  const queryClient = useQueryClient();
  const path = `${wallet}/profile`;
  const [fileURL, setFileURL] = useState<string>(initialFileURL);
  const [updating, setUpdating] = useState<boolean>();

  useEffect(() => {
    if (initialFileURL && initialFileURL !== fileURL)
      setFileURL(initialFileURL);
  }, [initialFileURL, fileURL]);

  let uploadFiles = async (acceptedFiles) => {
    setUpdating(true);
    const updateTime = Date.now();
    try {
      const uploadProfilePic = await supabase.storage
        .from("audio-files")
        .upload(path, acceptedFiles[0], {
          upsert: true,
        });

      if (uploadProfilePic.error) throw uploadProfilePic.error;

      const publicURLQuery = supabase.storage
        .from("audio-files")
        .getPublicUrl(`${wallet}/profile`);

      if (publicURLQuery.error) throw publicURLQuery.error;

      setFileURL(`${publicURLQuery.publicURL}?cacheBust=${updateTime}`);

      const profileUpsert = await supabase.from("profiles").upsert(
        {
          wallet,
          profilePic: publicURLQuery.publicURL,
          updateTime,
        },
        { onConflict: "wallet" }
      );

      if (profileUpsert.error) throw profileUpsert.error;
      await queryClient.invalidateQueries(["profile", wallet]);
    } catch (e) {
      console.error(e);
      toast.error(e);
    } finally {
      setUpdating(false);
    }
  };

  const onDrop = useCallback(
    (
      acceptedFiles: File[],
      fileRejections: FileRejection[],
      event: DropEvent
    ) => setFileSelected(acceptedFiles[0]),
    [path, queryClient, wallet]
  );

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: "image/jpeg,image/png",
  });

  const [isHovering, setIsHovering] = useState<boolean>();
  return (
    <HollowInputContainer
      type="form"
      {...getRootProps()}
      onMouseEnter={() => setIsHovering(true)}
      onMouseLeave={() => setIsHovering(false)}
    >
      <HollowInput {...getInputProps()} />
      <DropzoneText
        isUpdating={updating}
        isHovering={isHovering}
        isDragActive={isDragActive}
        fileSelected={fileSelected}
      />
    </HollowInputContainer>
  );
};

const DropzoneText = ({
  isUpdating,
  isHovering,
  isDragActive,
  fileSelected,
}) => {
  if (isUpdating) return <p className="text-base italic">{"Uploading..."}</p>;

  if (isHovering)
    return <p className="text-base italic">{"Upload new file"}</p>;

  if (isDragActive)
    return <p className="text-base italic">{"Drop file here"}</p>;

  if (!isHovering && !isDragActive && !fileSelected)
    return (
      <p className="text-base italic">{"Drop or select file to upload"}</p>
    );

  if (!!fileSelected && !isDragActive)
    return <p className="text-base bold">{"File selected!"}</p>;

  return null;
};
