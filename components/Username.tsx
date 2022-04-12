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
  return (
    <div
      className={linkToProfile ? "hover:opacity-50 cursor-pointer" : undefined}
      onClick={
        linkToProfile
          ? () => router.push(`/profile?wallet=${wallet}`)
          : undefined
      }
    >
      {profileQuery?.data?.username ? (
        profileQuery.data.username
      ) : (
        <ShortenedWallet wallet={wallet} />
      )}
    </div>
  );
};
