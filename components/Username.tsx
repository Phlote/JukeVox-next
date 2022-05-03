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

  let content = null;
  // if we have a username, use it
  if (username) content = username;
  // otherwise check if we have a valid wallet
  else if (validWallet) {
    if (profileQuery?.data?.username) content = profileQuery.data.username;
    else content = <ShortenedWallet wallet={wallet} />;
  }

  if (!content) throw "<Username/> is being used wrong";

  if (linkToProfile && username) {
    return (
      <Link href={"/profile/[username]"} as={`/profile/${username}`} passHref>
        <a className="hover:opacity-50 cursor-pointer">{content}</a>
      </Link>
    );
  }

  return <span>{content}</span>;
};
