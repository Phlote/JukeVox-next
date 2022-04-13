import { useWeb3React } from "@web3-react/core";
import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import { ProfileSettingsForm } from "../components/Forms/ProfileSettingsForm";
import Layout from "../components/Layouts";

function ProfileEdit() {
  const router = useRouter();
  const { account } = useWeb3React();

  return (
    <>
      <ProfileSettingsForm wallet={account} />

      {/* <HollowButtonContainer
        className="absolute bottom-0 right-10 cursor-pointer"
        onClick={() => router.push(`/profile?wallet=${account}`)}
      >
        <HollowButton>
          View My Curations{" "}
          <Image src="/arrow.svg" alt={"link"} height={12} width={12} />
        </HollowButton>
      </HollowButtonContainer> */}
    </>
  );
}

ProfileEdit.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto h-screen items-center  relative">
        {page}
      </div>
    </Layout>
  );
};

export default ProfileEdit;
