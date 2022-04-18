import Image from "next/image";
import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";
import { useField, useForm } from "react-final-form-hooks";
import { useQuery, useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { getProfile } from "../../controllers/profiles";
import { revalidateProfile } from "../../controllers/revalidate";
import { supabase } from "../../lib/supabase";
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
  profilePic: string; // url
  cosigns: number; // total number of cosigns that the user has earned on their submissions
}

export const ProfileSettingsForm = ({ wallet }) => {
  const queryClient = useQueryClient();
  const [submitting, setSubmitting] = React.useState<boolean>(false);

  const onSubmit = async (formData: Partial<UserProfile>) => {
    setSubmitting(true);
    try {
      const { username, city, twitter } = formData;
      const { data, error } = await supabase
        .from("profiles")
        .upsert({ wallet, username, city, twitter }, { onConflict: "wallet" });
      if (error) throw error;

      const submissionsUpdate = await supabase
        .from("submissions")
        .update({ username })
        .match({ curatorWallet: wallet });

      if (submissionsUpdate.error) throw submissionsUpdate.error;

      await queryClient.invalidateQueries(["profile", wallet]);
      await revalidateProfile(username);

      toast.success("Submitted!");
    } catch (e) {
      toast.error(e.message);
    } finally {
      setSubmitting(false);
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
          <HollowButton disabled={submitting}>Submit</HollowButton>
        </HollowButtonContainer>
      </div>
    </div>
  );
};

const ProfilePictureUpload = ({ wallet }) => {
  const queryClient = useQueryClient();
  const path = `${wallet}/profile`;
  const profile = useProfile(wallet);

  const onDrop = useCallback(
    async (acceptedFiles) => {
      const { error } = await supabase.storage
        .from("profile-pics")
        .upload(path, acceptedFiles[0], {
          cacheControl: "3600",
          upsert: true,
        });

      if (!error) {
        queryClient.refetchQueries(["profile", wallet]);
      } else {
        console.error(error);
        toast.error(error);
      }
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

      {isDragActive && <p className="text-base italic">{"Drop image here"}</p>}

      {profile?.data?.profilePic && !isDragActive && (
        <Image
          className={`rounded-full ${isHovering && "opacity-25"}`}
          src={profile?.data?.profilePic}
          objectFit={"cover"}
          layout="fill"
          alt="profile picture"
          priority
        />
      )}

      {!isHovering && !isDragActive && !profile?.data?.profilePic && (
        <p className="text-base italic">{"Drop or select visual to upload"}</p>
      )}
    </div>
  );
};

export const useProfile = (wallet) => {
  return useQuery(["profile", wallet], async () => {
    if (!wallet) return null;
    return getProfile(wallet);
  });
};
