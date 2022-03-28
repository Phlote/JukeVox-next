import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import { ProfileSettingsForm } from "../components/Forms/ProfileSettingsForm";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import { ProfileLayout } from "../components/Layouts";

function Profile() {
  const router = useRouter();
  const { account } = useWeb3React();

  return (
    <ProfileLayout>
      <ProfileSettingsForm wallet={account} />
      <HollowButtonContainer
        className="absolute bottom-10 right-10 cursor-pointer"
        onClick={() => router.push(`/myarchive?wallet=${account}`)}
      >
        <HollowButton>
          View My Curations{" "}
          <Image src="/arrow.svg" alt={"link"} height={12} width={12} />
        </HollowButton>
      </HollowButtonContainer>
    </ProfileLayout>
  );
}

export default Profile;
