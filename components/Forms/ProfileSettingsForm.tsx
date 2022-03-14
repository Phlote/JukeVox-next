import Image from "next/image";
import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";
import { useField, useForm } from "react-final-form-hooks";
import { useQuery, useQueryClient } from "react-query";
import { supabase } from "../../utils/supabase";
import {
  HollowButton,
  HollowButtonContainer,
  HollowInput,
  HollowInputContainer,
} from "../Hollow";

export interface UserProfile {
  profilePic?: string; // Not in DB
  wallet: string;
  handle: string;
  city: string;
  twitter: string;
}

export const ProfileSettingsForm = ({ wallet }) => {
  const queryClient = useQueryClient();

  const onSubmit = async (formData: Partial<UserProfile>) => {
    const { handle, city, twitter } = formData;
    const { data, error } = await supabase
      .from("profiles")
      .upsert({ wallet, handle, city, twitter });
    if (error) alert(error.message);
    else queryClient.invalidateQueries(["profile", wallet]);
  };

  const profile = useProfile(wallet);

  const { form, handleSubmit, valid } = useForm({
    onSubmit,
    initialValues: profile.data ?? undefined,
  });

  //TODO init values here
  //TODO need to check if handle is taken
  const handle = useField("handle", form);
  const city = useField("city", form);
  const twitter = useField("twitter", form);

  return (
    <div className="flex flex-row w-8/12">
      <div className="w-1/2">
        <ProfilePictureUpload wallet={wallet} />
      </div>
      <div className="flex flex-col items-center w-1/2">
        <div className="grid grid-cols-1 gap-4 my-auto">
          <HollowInputContainer type="form">
            <HollowInput
              {...handle.input}
              type="text"
              placeholder="Phlote handle"
            />
            {handle.meta.error && (
              <span className="text-red-600 ml-2">{handle.meta.error}</span>
            )}
          </HollowInputContainer>
          <HollowInputContainer type="form">
            <HollowInput {...city.input} type="text" placeholder="City" />
            {city.meta.error && (
              <span className="text-red-600 ml-2">{city.meta.error}</span>
            )}
          </HollowInputContainer>
          <HollowInputContainer type="form">
            <HollowInput {...twitter.input} type="text" placeholder="Twitter" />
            {twitter.meta.error && (
              <span className="text-red-600 ml-2">{twitter.meta.error}</span>
            )}
          </HollowInputContainer>
        </div>
        <HollowButtonContainer className="w-1/4">
          <HollowButton onClick={handleSubmit}>Submit</HollowButton>
        </HollowButtonContainer>
      </div>
    </div>
  );
};

const ProfilePictureUpload = ({ wallet }) => {
  const [profilePic, setProfilePic] = React.useState<string>();
  const profileQuery = useProfile(wallet);
  const queryClient = useQueryClient();
  const path = `${wallet}/profile`;

  React.useEffect(() => {
    if (profileQuery.data && !profilePic) {
      setProfilePic(profileQuery.data.profilePic);
    }
  }, [profileQuery.data, profilePic]);

  const onDrop = useCallback(
    async (acceptedFiles) => {
      const { error } = await supabase.storage
        .from("profile-pics")
        .upload(path, acceptedFiles[0], {
          cacheControl: "3600",
          upsert: true,
        });

      if (!error) {
        const url = URL.createObjectURL(acceptedFiles[0]);
        setProfilePic(url);
        queryClient.invalidateQueries("profile");
      } else alert(error); //TODO: error toasts?
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

      {profilePic && !isDragActive ? (
        <Image
          className="rounded-full"
          src={profilePic}
          objectFit={"cover"}
          layout="fill"
          alt="profile picture"
          priority
        />
      ) : (
        <p className="text-base italic">
          {isDragActive ? "Drop image here" : "Drop or select visual to upload"}
        </p>
      )}
    </div>
  );
};

export const useProfile = (wallet) => {
  const path = `${wallet}/profile`;

  const getProfileData = async () => {
    const profilePic = await supabase.storage
      .from("profile-pics")
      .getPublicUrl(path);
    const query = await supabase.from("profiles").select().match({ wallet });
    const profileMeta = query.data[0] as UserProfile;
    return {
      profilePic: profilePic.data.publicURL,
      ...profileMeta,
    } as UserProfile;
  };

  return useQuery(["profile", wallet], getProfileData);
};
