import cn from "classnames";
import Image from "next/image";
import React from "react";
import { UserProfile } from "../Forms/ProfileSettingsForm";

interface Props {
  profile?: UserProfile | null;
  className?: string | { [key: string]: any };
  isDeleted?: boolean;
  firstLetter?: string;
}

const Avatar = ({
  profile,
  className = "w-7 h-7 text-sm",
  isDeleted,
  firstLetter,
}: Props): JSX.Element => {
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

  if (profile?.profilePic) {
    return (
      <Image
        src={profile.profilePic}
        className={cn(
          "rounded-full border border-white shadow-sm object-cover",
          className
        )}
        alt={profile?.username}
        width={28}
        height={28}
      />
    );
  }

  if (profile?.username) {
    return (
      <div
        className={cn(
          "rounded-full border border-white bg-indigo-600 text-white shadow-sm flex items-center justify-center capitalize font-light",
          className
        )}
      >
        {profile?.username?.[0]}
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
