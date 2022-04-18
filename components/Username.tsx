import { ethers } from "ethers";
import Link from "next/link";
import { ShortenedWallet } from "./ShortenedWallet";
interface Username {
  wallet?: string;
  username?: string;
  linkToProfile?: boolean;
}

export const Username: React.FC<Username> = (props) => {
  const { wallet, username, linkToProfile } = props;

  let content;

  if (wallet && ethers.utils.isAddress(wallet))
    content = <ShortenedWallet wallet={wallet} />;
  if (username) content = username;

  if (linkToProfile && username) {
    return (
      <Link href={"/profile/[username]"} as={`/profile/${username}`} passHref>
        <div className="hover:opacity-50 cursor-pointer">{content}</div>
      </Link>
    );
  }

  return <span>{content}</span>;
};
