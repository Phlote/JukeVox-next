import { ethers } from "ethers";
import Link from "next/link";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { ShortenedWallet } from "./ShortenedWallet";

interface Username {
  wallet?: string;
  username?: string;
  linkToProfile?: boolean;
}

export const Username: React.FC<Username> = (props) => {
  const { wallet, username, linkToProfile } = props;
  const validWallet = wallet && ethers.utils.isAddress(wallet);

  let content = null;
  // if we have a username, use it
  if (username) content = username;
  // otherwise check if we have a valid wallet
  else if (validWallet) {
    content = <ShortenedWallet wallet={wallet} />;
  }

  if (!content) throw "<Username/> is being used wrong";

  if (linkToProfile) {
    return (
      <Link
        href={"/profile/[uuid]"}
        as={`/profile/${wallet}`}
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
