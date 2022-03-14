import { ShortenedWallet } from "./Account";
import { useProfile } from "./Forms/ProfileSettingsForm";

export const Username = ({ wallet }) => {
  const profileQuery = useProfile(wallet);
  if (profileQuery?.data?.username)
    return <span>{profileQuery.data.username}</span>;
  else return <ShortenedWallet wallet={wallet} />;
};
