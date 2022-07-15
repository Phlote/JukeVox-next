import React, {useCallback, useEffect, useState} from "react";
import {useQueryClient} from "react-query";
import {supabase} from "../lib/supabase";
import {toast} from "react-toastify";
import {DropEvent, FileRejection, useDropzone} from "react-dropzone";
import {HollowInput, HollowInputContainer} from "./Hollow";
import {QueryClient} from "react-query/core";

interface FileUploadProps {
  wallet: string;
  fileSelected: File;
  setFileSelected: React.Dispatch<React.SetStateAction<File>>;
  updating: boolean;
}

interface uploadFilesArguments {
  acceptedFiles: File;
  wallet: string;
  queryClient: QueryClient;
  fileURL: string;
  setFileURL: (string) => void;
  updating: boolean;
  setUpdating: (boolean) => void;
}

//I feel like I am doing something wrong here having to pass so many arguments around
export const uploadFiles = async (args: uploadFilesArguments) => {//TODO: use this function on submit button click
  let { acceptedFiles, wallet, queryClient, fileURL, setFileURL, updating, setUpdating } = args;

  setUpdating(true);
  const path = `${wallet}/profile`;
  const updateTime = Date.now();
  try {
    const uploadAudioFile = await supabase.storage
      .from("audio-files")
      .upload(path, acceptedFiles[0], {
        upsert: true,
      });

    if (uploadAudioFile.error) throw uploadAudioFile.error;

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
  return fileURL;
};

export const FileUpload: React.FC<FileUploadProps> = ({
                                                        wallet,
                                                        fileSelected,
                                                        setFileSelected,
                                                        updating}) => {
  const queryClient = useQueryClient();
  const path = `${wallet}/profile`;

  const onDrop = useCallback(
    (
      acceptedFiles: File[],//TODO: define accepted file types
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

const DropzoneText = ({isUpdating, isHovering, isDragActive, fileSelected}) => {
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
