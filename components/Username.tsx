import { ShortenedWallet } from "./Account";
import { useProfile } from "./Forms/ProfileSettingsForm";

export const Username = ({ wallet }) => {
  const profileQuery = useProfile(wallet);
  return (
    <a className="hover:opacity-50" href={`/myarchive?wallet=${wallet}`}>
      {profileQuery?.data?.username ? (
        profileQuery.data.username
      ) : (
        <ShortenedWallet wallet={wallet} />
      )}
    </a>
  );
};
