import { ethers } from "ethers";
import Link from "next/link";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { ShortenedWallet } from "./ShortenedWallet";
import { useState } from "react";

interface Username {
  wallet?: string;
  linkToProfile?: boolean;
}

//REFERENCE: for how to define types on JSX react function
export const Username = (props: Username): JSX.Element => {
  const { wallet, linkToProfile } = props;
  const [username, setUsername] = useState('');

  const validWallet = wallet && ethers.utils.isAddress(wallet);
  const profileQuery = useProfile(wallet, {
    enabled: !username && validWallet,
  });
  setUsername(profileQuery?.data?.username);

  let content = null;
  // if we have a username, use it
  if (username) {
    content = username;
  } else if (validWallet) { // otherwise check if we have a valid wallet
    if (profileQuery?.data?.username) content = profileQuery.data.username;
    else content = <ShortenedWallet wallet={wallet} />;
  }

  if (!content) throw "<Username/> is being used wrong";

  if (linkToProfile) {
    return (
      <Link
        href={"/profile/[uuid]"}
        as={`/profile/${username ? username : wallet}`}
        passHref
      >
        <a
          onClick={(e) => e.stopPropagation()}
          className="hover:opacity-50 cursor-pointer"
        >
          {content}
        </a>
      </Link>
    );
  }

  return <span>{content}</span>;
};
