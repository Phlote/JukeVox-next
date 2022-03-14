import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import { useRouter } from "next/router";
import React from "react";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { ProfileSettingsForm } from "../components/Forms/ProfileSettingsForm";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import { ProfileLayout } from "../components/Layouts";

function Profile() {
  const router = useRouter();
  const { wallet } = router.query;
  const { account } = useWeb3React();

  React.useEffect(() => {
    if (account !== wallet) router.replace("/");
  }, [account, router, wallet]);

  return (
    <ProfileLayout>
      <ProfileSettingsForm wallet={wallet} />
      <ToastContainer position="bottom-right" autoClose={5000} />
      <HollowButtonContainer
        className="absolute bottom-10 right-10 cursor-pointer"
        onClick={() => router.push(`/myarchive?wallet=${wallet}`)}
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
