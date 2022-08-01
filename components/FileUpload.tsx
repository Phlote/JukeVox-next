import React, { useCallback, useEffect, useState } from "react";
import { DropEvent, FileRejection, useDropzone } from "react-dropzone";
import { toast } from "react-toastify";
import { pinFile } from "../controllers/moralis";
import { HollowInput, HollowInputContainer } from "./Hollow";
import ReactTooltip from "react-tooltip";
import { supabase } from "../lib/supabase";

interface FileUploadProps {
  wallet: string;
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

    console.log(acceptedFile);

    const uploadAudioFile = await supabase.storage
      .from("audio-files")
      .upload(hash, acceptedFile, {
        contentType: acceptedFile.type,
      });

    if (uploadAudioFile.error) throw uploadAudioFile.error;

    const publicURLQuery = supabase.storage
      .from("audio-files")
      .getPublicUrl(hash);

    if (publicURLQuery.error) throw publicURLQuery.error;

    return publicURLQuery.publicURL;
  } catch (e) {
    console.error(e);
    toast.error(e);
  } finally {
  }
};

export const FileUpload: React.FC<FileUploadProps> = ({
  fileSelected,
  setFileSelected,
}) => {
  useEffect(() => ReactTooltip.rebuild() as () => (void),[]);

  const onDrop = useCallback(
    (
      acceptedFiles: File[], //TODO: define accepted file types
      fileRejections: FileRejection[],
      event: DropEvent
    ) => {
      if (fileRejections.length > 0){
        const fileRej = fileRejections[0];
        fileRej.errors.forEach((err) => {
          if (err.code === "file-too-large") {
            toast.error(`Error: ${err.message}`);
          }
          if (err.code === "file-invalid-type") {
            toast.error(`Error: ${err.message}`);
          }
        });
      }
      console.log("Reaches?");
      setFileSelected(acceptedFiles[0]);
    },
    [setFileSelected]
  );

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: ["audio/mpeg", "audio/wav", "application/pdf", "video/quicktime"],
    maxSize: 5242880
  });

  const [isHovering, setIsHovering] = useState<boolean>();
  return (
    <HollowInputContainer
      type="form"
      {...getRootProps()}
      onMouseEnter={() => setIsHovering(true)}
      onMouseLeave={() => setIsHovering(false)}
      data-tip='Max file size: 5mb'
    >
      <HollowInput {...getInputProps()} />
      <DropzoneText
        isHovering={isHovering}
        isDragActive={isDragActive}
        fileSelected={fileSelected}
        fileName={fileSelected?.name}
      />
    </HollowInputContainer>
  );
};

const DropzoneText = ({ isHovering, isDragActive, fileSelected, fileName }) => {
  if (isHovering)
    return <p className="text-base italic">{"Upload new file"}</p>;

  if (isDragActive)
    return <p className="text-base italic">{"Drop file here"}</p>;

  if (!isHovering && !isDragActive && !fileSelected)
    return (
      <p className="text-base italic">{"Drop or select file to upload"}</p>
    );

  if (!!fileSelected && !isDragActive)
    return <p className="text-base bold">{fileName}</p>;

  return null;
};
