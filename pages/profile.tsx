import { useRouter } from "next/router";
import { ProfileSettingsForm } from "../components/Forms/ProfileSettingsForm";
import { ProfileLayout } from "../components/Layouts";

function Profile() {
  const router = useRouter();
  const { wallet } = router.query;

  return (
    <ProfileLayout>
      <ProfileSettingsForm wallet={wallet} />
    </ProfileLayout>
  );
}

export default Profile;
