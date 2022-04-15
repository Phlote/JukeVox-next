import Link from "next/link";
import { useRouter } from "next/router";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { ShortenedWallet } from "./ShortenedWallet";

interface Username {
  wallet: string;
  linkToProfile?: boolean;
}

export const Username: React.FC<Username> = ({ wallet, linkToProfile }) => {
  const profileQuery = useProfile(wallet);
  const router = useRouter();

  const username = profileQuery?.data?.username ? (
    profileQuery?.data?.username
  ) : (
    <ShortenedWallet wallet={wallet} />
  );

  if (linkToProfile) {
    return (
      <Link href={`/profile/${encodeURIComponent(wallet)}`} passHref>
        <div className="hover:opacity-50 cursor-pointer">{username}</div>
      </Link>
    );
  }

  return <div>{username}</div>;
};
