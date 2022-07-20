import React, { useCallback, useState } from "react";
import { DropEvent, FileRejection, useDropzone } from "react-dropzone";
import { toast } from "react-toastify";
import { pinFile } from "../controllers/moralis";
import { HollowInput, HollowInputContainer } from "./Hollow";

interface FileUploadProps {
  wallet: string;
  fileSelected: File;
  setFileSelected: React.Dispatch<React.SetStateAction<File>>;
  updating: boolean;
}

interface uploadFilesArguments {
  acceptedFile: File;
  setUpdating: (boolean) => void;
}

export const uploadFiles = async (args: uploadFilesArguments) => {
  //TODO: use this function on submit button click
  let { acceptedFile, setUpdating } = args;

  setUpdating(true);
  try {
    const { uri, hash } = await pinFile(acceptedFile);

    return uri;
  } catch (e) {
    console.error(e);
    toast.error(e);
  } finally {
    setUpdating(false);
  }
};

export const FileUpload: React.FC<FileUploadProps> = ({
  fileSelected,
  setFileSelected,
  updating,
}) => {
  const onDrop = useCallback(
    (
      acceptedFiles: File[], //TODO: define accepted file types
      fileRejections: FileRejection[],
      event: DropEvent
    ) => setFileSelected(acceptedFiles[0]),
    [setFileSelected]
  );

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: "audio/mpeg",
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
