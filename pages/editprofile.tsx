import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import { ProfileSettingsForm } from "../components/Forms/ProfileSettingsForm";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import Layout from "../components/Layouts";

function ProfileEdit() {
  const router = useRouter();
  const { account } = useWeb3React();

  return (
    <>
      <ProfileSettingsForm wallet={account} />

      <div className="lg:block hidden">
        <HollowButtonContainer
          className="bottom-24 right-10 cursor-pointer"
          style={{ position: "absolute" }}
          onClick={() => router.push(`/profile?wallet=${account}`)}
        >
          <HollowButton>
            View My Curations{" "}
            <Image src="/arrow.svg" alt={"link"} height={12} width={12} />
          </HollowButton>
        </HollowButtonContainer>
      </div>
    </>
  );
}

ProfileEdit.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center items-center mx-auto flex-grow">
        {page}
      </div>
    </Layout>
  );
};

export default ProfileEdit;
