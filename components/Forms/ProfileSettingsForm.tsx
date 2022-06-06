import Image from "next/image";
import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";
import { useField, useForm } from "react-final-form-hooks";
import { useQuery, useQueryClient } from "react-query";
import { toast } from "react-toastify";
import { getProfile } from "../../controllers/profiles";
import { revalidate } from "../../controllers/revalidate";
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
  email: string;
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
      const { username, city, twitter, email } = formData;
      const { data, error } = await supabase.from("profiles").upsert(
        {
          wallet,
          email: email?.trim(),
          username: username?.trim(),
          city: city?.trim(),
          twitter: twitter?.trim(),
        },
        { onConflict: "wallet" }
      );
      if (error) throw error;

      const submissionsUpdate = await supabase
        .from("submissions")
        .update({ username })
        .match({ curatorWallet: wallet });

      if (submissionsUpdate.error) throw submissionsUpdate.error;

      await queryClient.invalidateQueries(["profile", wallet]);
      await revalidate(username);
      toast.success("Submitted!");
    } catch (e) {
      toast.error(e);
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
  const email = useField("email", form);

  return (
    // <div className="grid lg:grid-cols-2 grid-cols-1 w-10/12 md:gap-16 gap-8 h-full flex flex-grow">
    <div className="grid lg:grid-cols-2 grid-cols-1 w-10/12 md:gap-16 gap-1 max-h-full flex flex-grow my-8">
      <div className="flex justify-center items-center">
        <ProfilePictureUpload
          wallet={wallet}
          initialImageURL={profile?.data?.profilePic}
        />
      </div>

      <div className="flex flex-col items-center justify-center">
        <div className="grid grid-cols-1 gap-4 lg:w-full w-3/4">
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
          <HollowInputContainer type="form">
            <HollowInput {...email.input} type="text" placeholder="Email" />
            {email.meta.error && (
              <span className="text-red-600 ml-2">{email.meta.error}</span>
            )}
          </HollowInputContainer>
          <div className="w-full flex justify-center items-center">
            <HollowButtonContainer
              className="lg:w-1/4  w-full"
              onClick={handleSubmit}
            >
              <HollowButton disabled={submitting}>Submit</HollowButton>
            </HollowButtonContainer>
          </div>
        </div>
      </div>
    </div>
  );
};

const ProfilePictureUpload = ({ wallet, initialImageURL }) => {
  const queryClient = useQueryClient();
  const path = `${wallet}/profile`;
  const [imageURL, setImageURL] = React.useState<string>(initialImageURL);
  const [updating, setUpdating] = React.useState<boolean>();

  React.useEffect(() => {
    if (initialImageURL && initialImageURL !== imageURL)
      setImageURL(initialImageURL);
  }, [initialImageURL, imageURL]);

  const onDrop = useCallback(
    async (acceptedFiles) => {
      setUpdating(true);
      const updateTime = Date.now();
      try {
        const uploadProfilePic = await supabase.storage
          .from("profile-pics")
          .upload(path, acceptedFiles[0], {
            upsert: true,
          });

        if (uploadProfilePic.error) throw uploadProfilePic.error;

        const publicURLQuery = supabase.storage
          .from("profile-pics")
          .getPublicUrl(`${wallet}/profile`);

        if (publicURLQuery.error) throw publicURLQuery.error;

        setImageURL(`${publicURLQuery.publicURL}?cacheBust=${updateTime}`);

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
      className="lg:w-80 lg:h-80 md:w-44 md:h-44 w-28 h-28 border-2 border-white rounded-full flex justify-center items-center text-center relative"
      {...getRootProps()}
      onMouseEnter={() => setIsHovering(true)}
      onMouseLeave={() => setIsHovering(false)}
    >
      <input {...getInputProps()} />

      <DropzoneText
        isUpdating={updating}
        isHovering={isHovering}
        isDragActive={isDragActive}
        profilePic={imageURL}
      />

      {imageURL && !isDragActive && (
        <Image
          className={`rounded-full ${(isHovering || updating) && "opacity-25"}`}
          src={imageURL}
          objectFit={"cover"}
          layout="fill"
          alt="profile picture"
          priority
        />
      )}
    </div>
  );
};

const DropzoneText = ({ isUpdating, isHovering, isDragActive, profilePic }) => {
  if (isUpdating) return <p className="text-base italic">{"Updating..."}</p>;

  if (isHovering)
    return <p className="text-base italic">{"Upload new photo"}</p>;

  if (isDragActive)
    return <p className="text-base italic">{"Drop image here"}</p>;

  if (!isHovering && !isDragActive && !profilePic)
    return (
      <p className="text-base italic">{"Drop or select visual to upload"}</p>
    );

  return null;
};

export const useProfile = (wallet, options = {}) => {
  return useQuery(
    ["profile", wallet],
    async () => {
      if (!wallet) return null;
      return getProfile(wallet);
    },
    { refetchOnWindowFocus: false, keepPreviousData: true, ...options }
  );
};
