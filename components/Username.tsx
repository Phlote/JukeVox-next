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
  const profileQuery = useProfile(wallet, {
    enabled: !username && validWallet,
  });

  let content;

  if (username) content = username;
  else if (validWallet) {
    if (profileQuery?.data?.username) content = profileQuery.data.username;
    else content = <ShortenedWallet wallet={wallet} />;
  }

  // if a username is provided, simply use this

  if (linkToProfile && username) {
    return (
      <Link href={"/profile/[username]"} as={`/profile/${username}`} passHref>
        <div className="hover:opacity-50 cursor-pointer">{content}</div>
      </Link>
    );
  }

  return <span>{content}</span>;
};
