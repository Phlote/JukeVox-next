import { useRouter } from "next/router";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { ProfileSettingsForm } from "../components/Forms/ProfileSettingsForm";
import { ProfileLayout } from "../components/Layouts";

function Profile() {
  const router = useRouter();
  const { wallet } = router.query;

  return (
    <ProfileLayout>
      <ProfileSettingsForm wallet={wallet} />
      <ToastContainer position="bottom-right" autoClose={5000} />
    </ProfileLayout>
  );
}

export default Profile;
