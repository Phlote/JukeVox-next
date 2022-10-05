import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import {
  ProfileSettingsForm,
  useProfile,
} from "../components/Forms/ProfileSettingsForm";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import Layout from "../components/Layouts";
import { useMoralis } from "react-moralis";

function ProfileEdit() {
  const router = useRouter();
  const { account } = useMoralis();
  const profileQuery = useProfile(account);

  return (
    <>
      <div
        className="sm:hidden absolute top-5 left-5"
        onClick={() => router.back()}
      >
        <Image
          // className={dropdownOpen ? "-rotate-90" : "rotate-90"}
          className="rotate-180"
          src={"/chevron.svg"}
          alt="dropdown"
          height={16}
          width={16}
        />
      </div>
      <ProfileSettingsForm wallet={account} />

      <div className="lg:block hidden">
        {profileQuery?.data?.username && (
          <Link
            as={`/profile/${profileQuery?.data?.username}`}
            href="/profile/[username]"
            passHref
          >
            <HollowButtonContainer
              className="bottom-20 right-10 cursor-pointer"
              style={{ position: "absolute" }}
            >
              <HollowButton>
                View My Submissions{" "}
                <Image src="/arrow.svg" alt={"link"} height={12} width={12} />
              </HollowButton>
            </HollowButtonContainer>
          </Link>
        )}
      </div>
    </>
  );
}

ProfileEdit.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto flex-grow h-full">
        {page}
      </div>
    </Layout>
  );
};

export default ProfileEdit;
