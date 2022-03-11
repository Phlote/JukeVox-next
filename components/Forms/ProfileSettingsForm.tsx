import Image from "next/image";
import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";
import { useField, useForm } from "react-final-form-hooks";
import { supabase } from "../../utils/supabase";
import { HollowInput, HollowInputContainer } from "../Hollow";

export const ProfileSettingsForm = ({ onSubmit, wallet }) => {
  const { form, handleSubmit, valid } = useForm({
    onSubmit,
    // validate: validateCurationSubmission,
  });
  //TODO init values here
  //TODO need to check if handle is taken

  const profileName = useField("profileName", form);
  const handle = useField("handle", form);
  const city = useField("city", form);
  const twitter = useField("twitter", form);
  const discord = useField("discord", form);

  return (
    <div className="flex flex-row w-3/4">
      <div className="w-1/2">
        <ProfilePictureUpload wallet={wallet} />
      </div>
      <div className="w-1/2 grid grid-cols-2 gap-4 my-auto">
        <HollowInputContainer type="form">
          <HollowInput
            {...profileName.input}
            type="text"
            placeholder="Profile Name"
          />
          {profileName.meta.error && (
            <span className="text-red-600 ml-2">{profileName.meta.error}</span>
          )}
        </HollowInputContainer>
        <HollowInputContainer type="form">
          <HollowInput {...twitter.input} type="text" placeholder="twitter" />
          {twitter.meta.error && (
            <span className="text-red-600 ml-2">{twitter.meta.error}</span>
          )}
        </HollowInputContainer>
        <HollowInputContainer type="form">
          <HollowInput
            {...handle.input}
            type="text"
            placeholder="Claim your handle"
          />
          {handle.meta.error && (
            <span className="text-red-600 ml-2">{handle.meta.error}</span>
          )}
        </HollowInputContainer>
        <HollowInputContainer type="form">
          <HollowInput {...discord.input} type="text" placeholder="discord " />
          {discord.meta.error && (
            <span className="text-red-600 ml-2">{discord.meta.error}</span>
          )}
        </HollowInputContainer>
        <HollowInputContainer type="form">
          <HollowInput {...city.input} type="text" placeholder="City you rep" />
          {city.meta.error && (
            <span className="text-red-600 ml-2">{city.meta.error}</span>
          )}
        </HollowInputContainer>
      </div>
    </div>
  );
};

const ProfilePictureUpload = ({ wallet }) => {
  const [profilePic, setProfilePic] = React.useState<string>();
  const path = `${wallet}/profile`;

  // TODO: use query?
  React.useEffect(() => {
    const getProfilePic = async () => {
      const { data, error } = await supabase.storage
        .from("profile-pics")
        .download(path);

      const url = URL.createObjectURL(data);
      setProfilePic(url);
    };
    if (wallet) getProfilePic();
  }, [wallet]);

  const onDrop = useCallback(
    async (acceptedFiles) => {
      const { data, error } = await supabase.storage
        .from("profile-pics")
        .upload(path, acceptedFiles[0], {
          cacheControl: "3600",
          upsert: true,
        });

      const url = URL.createObjectURL(acceptedFiles[0]);
      setProfilePic(url);
    },
    [wallet]
  );
  const { getRootProps, getInputProps, isDragActive } = useDropzone({ onDrop });

  return (
    <div
      className="w-80 h-80 border-2 border-white rounded-full flex justify-center items-center relative"
      {...getRootProps()}
    >
      <input {...getInputProps()} />
      {/* {isDragActive ? (
        <p>Drop the files here ...</p>
      ) : (
        <p className="text-base italic">Drop or select visual to upload</p>
      )} */}
      {profilePic ? (
        <Image
          className="rounded-full"
          src={profilePic}
          objectFit={"cover"}
          layout="fill"
          alt="profile picture"
        />
      ) : (
        <p className="text-base italic">Drop or select visual to upload</p>
      )}
    </div>
  );
};
