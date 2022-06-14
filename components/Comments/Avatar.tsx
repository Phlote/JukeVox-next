import cn from "classnames";
import Image from "next/image";
import React from "react";
import { useProfile } from "../Forms/ProfileSettingsForm";

interface Props {
  wallet: string;
  className?: string | { [key: string]: any };
  isDeleted?: boolean;
  firstLetter?: string;
}

const Avatar = ({
  wallet,
  className = "w-7 h-7 text-sm",
  isDeleted,
  firstLetter,
}: Props): JSX.Element => {
  const profile = useProfile(wallet);
  if (isDeleted) {
    return (
      <div
        className={cn(
          "rounded-full border border-white shadow-sm bg-gray-500",
          className
        )}
      ></div>
    );
  }

  if (firstLetter) {
    return (
      <div
        className={cn(
          "rounded-full border border-white bg-indigo-600 text-white shadow-sm flex items-center justify-center capitalize font-light",
          className
        )}
      >
        {firstLetter}
      </div>
    );
  }

  if (profile?.data?.profilePic) {
    return (
      <Image
        src={profile?.data?.profilePic}
        className={cn(
          "rounded-full border border-white shadow-sm object-cover",
          className
        )}
        alt={profile?.data?.username}
        width={28}
        height={28}
      />
    );
  }

  if (profile?.data?.username) {
    return (
      <div
        className={cn(
          "rounded-full border border-white bg-indigo-600 text-white shadow-sm flex items-center justify-center capitalize font-light",
          className
        )}
      >
        {profile?.data?.username?.[0]}
      </div>
    );
  }

  return (
    <div
      className={cn(
        "skeleton rounded-full border border-white bg-indigo-600 text-white shadow-sm flex items-center justify-center capitalize font-light",
        className
      )}
    ></div>
  );
};

export default Avatar;
