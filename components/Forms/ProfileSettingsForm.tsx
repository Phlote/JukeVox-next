import Image from "next/image";
import { useRouter } from "next/router";
import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";
import { useField, useForm } from "react-final-form-hooks";
import { useQuery, useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { supabase } from "../../utils/supabase";
import {
  HollowButton,
  HollowButtonContainer,
  HollowInput,
  HollowInputContainer,
} from "../Hollow";
import { validateProfileSettings } from "./validators";

export interface UserProfile {
  wallet: string; // user has already connected wallet, so this is not a form field
  username: string;
  city: string;
  twitter: string;
}

export const ProfileSettingsForm = ({ wallet }) => {
  const queryClient = useQueryClient();
  const router = useRouter();

  const onSubmit = async (formData: Partial<UserProfile>) => {
    const { username, city, twitter } = formData;
    const { data, error } = await supabase
      .from("profiles")
      .upsert({ wallet, username, city, twitter });
    if (error) toast.error(error.message);
    else {
      queryClient.invalidateQueries(["profile", wallet]);
      toast.success("Sumbitted!");
    }
  };

  const profile = useProfile(wallet);

  const { form, handleSubmit } = useForm({
    onSubmit,
    validate: validateProfileSettings,
    initialValues: profile.data ?? undefined,
  });

  const username = useField("username", form);
  const city = useField("city", form);
  const twitter = useField("twitter", form);

  return (
    <div className="flex flex-row w-10/12">
      <div className="w-1/2">
        <ProfilePictureUpload wallet={wallet} />
      </div>
      <div className="flex flex-col items-center w-1/2">
        <div className="grid grid-cols-1 gap-4 w-full mr-auto my-auto relative">
          <HollowInputContainer type="form">
            {username.meta.error && (
              <p className="absolute text-red-600 -top-10">
                {username.meta.error}
              </p>
            )}
            <HollowInput
              {...username.input}
              type="text"
              placeholder="Username"
            />
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
        <HollowButtonContainer className="w-1/4" onClick={handleSubmit}>
          <HollowButton>Submit</HollowButton>
        </HollowButtonContainer>
      </div>
    </div>
  );
};

const ProfilePictureUpload = ({ wallet }) => {
  const queryClient = useQueryClient();
  const path = `${wallet}/profile`;
  const profilePicQuery = useProfilePic(wallet);

  const onDrop = useCallback(
    async (acceptedFiles) => {
      const { error } = await supabase.storage
        .from("profile-pics")
        .upload(path, acceptedFiles[0], {
          cacheControl: "3600",
          upsert: true,
        });

      if (!error) {
        queryClient.refetchQueries(["profile-pic", wallet]);
      } else toast.error(error);
    },
    [path, queryClient, wallet]
  );
  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: "image/jpeg,image/png",
  });

  const [isHovering, setIsHovering] = React.useState<boolean>();
  return (
    <div
      className="w-80 h-80 border-2 border-white rounded-full flex justify-center items-center relative"
      {...getRootProps()}
      onMouseEnter={() => setIsHovering(true)}
      onMouseLeave={() => setIsHovering(false)}
    >
      <input {...getInputProps()} />

      {isHovering && <p className="text-base italic">{"Upload new photo"}</p>}

      {profilePicQuery?.data && !isDragActive ? (
        <Image
          className={`rounded-full ${isHovering && "opacity-25"}`}
          src={profilePicQuery?.data}
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
  const getProfileData = async () => {
    const query = await supabase.from("profiles").select().match({ wallet });
    const profileMeta = query.data[0] as UserProfile;
    return profileMeta as UserProfile;
  };

  return useQuery(["profile", wallet], getProfileData);
};

export const useProfilePic = (wallet) => {
  const path = `${wallet}/profile`;

  const getProfilePic = async () => {
    if (!wallet) return null;

    const { data, error } = await supabase.storage
      .from("profile-pics")
      .download(path);

    if (error) {
      toast.error(error);
      return null;
    }

    const url = URL.createObjectURL(data);
    return url;
  };

  return useQuery(["profile-pic", wallet], getProfilePic);
};
