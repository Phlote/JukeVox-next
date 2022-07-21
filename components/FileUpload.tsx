import React, { useCallback, useState } from "react";
import { DropEvent, FileRejection, useDropzone } from "react-dropzone";
import { toast } from "react-toastify";
import { pinFile } from "../controllers/moralis";
import { HollowInput, HollowInputContainer } from "./Hollow";

interface FileUploadProps {
  fileUpload: {
    input: {
      onChange: (field: string) => void,
      onFocus?: () => void
    }, meta: {
      touched: boolean,
      visited: boolean,
      error: string
    }
  };
  fileSelected: File;
  setFileSelected: React.Dispatch<React.SetStateAction<File>>;
}

interface uploadFilesArguments {
  acceptedFile: File;
}

export const uploadFiles = async (args: uploadFilesArguments) => {
  let { acceptedFile } = args;

  try {
    const { uri, hash } = await pinFile(acceptedFile);

    return uri;
  } catch (e) {
    console.error(e);
    toast.error(e);
  } finally {

  }
};

export const FileUpload: React.FC<FileUploadProps> = ({
  fileUpload,
  fileSelected,
  setFileSelected,
}) => {
  React.useEffect(() => {
    return () => {
      if (fileUpload.input.onFocus) fileUpload.input.onFocus();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  console.log(fileUpload);
  const onDrop = useCallback(
    (
      acceptedFiles: File[], //TODO: define accepted file types
      fileRejections: FileRejection[],
      event: DropEvent
    ) => {
      setFileSelected(acceptedFiles[0]);
      fileUpload.input.onChange(acceptedFiles[0].name);
    },
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
        isHovering={isHovering}
        isDragActive={isDragActive}
        fileSelected={fileSelected}
        fileName={fileSelected?.name}
      />
      {(fileUpload.meta.touched || fileUpload.meta.visited) &&
        fileUpload.meta.error && (
          <span className="text-red-600 ml-2">{fileUpload.meta.error}</span>
        )}
    </HollowInputContainer>
  );
};

const DropzoneText = ({
  isHovering,
  isDragActive,
  fileSelected,
  fileName
}) => {
  if (isHovering)
    return <p className="text-base italic">{"Upload new file"}</p>;

  if (isDragActive)
    return <p className="text-base italic">{"Drop file here"}</p>;

  if (!isHovering && !isDragActive && !fileSelected)
    return (
      <p className="text-base italic">{"Drop or select file to upload"}</p>
    );

  if (!!fileSelected && !isDragActive)
    return <p className="text-base bold">{"Selected: " + fileName}</p>;

  return null;
};
