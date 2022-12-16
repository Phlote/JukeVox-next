import Link from "next/link";
import { useRouter } from "next/router";
import tw from "twin.macro";
import { useIsCurator } from "../hooks/useIsCurator";
import Close from "../public/close.svg";
import Account from "./Account";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { HollowButtonContainer, HollowInputContainer } from "./Hollow";
import { SearchBar } from "./SearchBar";
import { useSubmissionFlowOpen } from "./SubmissionFlow";
import { useMoralis } from "react-moralis";
import BETABlog from "../pages/BETABlog";
import Image from "next/image";

export const NavBarMobileWeb = () => {
  const [, setOpen] = useSubmissionFlowOpen();
  const { isWeb3Enabled } = useMoralis();
  return (
    <div className="w-screen flex flex-row flex-none bg-phlote-container divide-x absolute bottom-0">
      {isWeb3Enabled && (
        <MobileNavBarElementContainer
          className="focus:opacity-25"
          onClick={(e) => {
            setOpen(true);
            (e.target as any).blur();
          }}
        >
          Submit
        </MobileNavBarElementContainer>
      )}
      <MobileNavBarElementContainer>
        <Account />
      </MobileNavBarElementContainer>
    </div>
  );
};

const MobileNavBarElementContainer = tw.button`h-full w-full py-8 text-center `;

export const NavBarDesktop = (props) => {
  const [, setOpen] = useSubmissionFlowOpen();
  const router = useRouter();
  const { isWeb3Enabled, account } = useMoralis();
  const profileQuery = useProfile(account);
  const isCuratorQuery = useIsCurator();

  return (
    <div className="pb-4 flex-none w-screen px-12 absolute top-0">
      <div className="py-2 flex justify-center items-center backdrop-blur-md">
        <p className="text-center cursor-pointer text-xl text-red-500 hover:text-blue-600"><Link href ={"BETABlog"} passHref><b>Announcement:<u>We&apos;re live in BETA! Read More about it here...</u></b></Link></p>
      </div>
      <div className="relative flex flex-row gap-4 items-center" style={{ height: 70 }}>
        <Link href="/" passHref >
          <div className='w-48 h-24 relative'>
            <Image src='/newLogo.png' className="cursor-pointer object-contain" alt='' layout='fill'/>
          </div>
        </Link>
        <div className="flex-grow" />
        <NavBarElementContainer>
          <Link href="/archive" passHref>
            <HollowButtonContainer className="flex justify-center items-center ">
              Feed
            </HollowButtonContainer>
          </Link>
        </NavBarElementContainer>
        <NavBarElementContainer>
          <Link href="/about-us" passHref>
            <HollowButtonContainer className="flex justify-center items-center ">
              About Us
            </HollowButtonContainer>
          </Link>
        </NavBarElementContainer>
        <NavBarElementContainer>
          <Link href="/how-it-works" passHref>
            <HollowButtonContainer className="flex justify-center items-center ">
              How it works
            </HollowButtonContainer>
          </Link>
        </NavBarElementContainer>
        {isWeb3Enabled && (
          <NavBarElementContainer>
            <Link
              href={"/profile/[uuid]"}
              as={`/profile/${account}`}
              passHref
            >
              <HollowButtonContainer className="flex justify-center items-center ">
                My Profile
              </HollowButtonContainer>
            </Link>
          </NavBarElementContainer>
        )}
        {router.pathname == "/archive" && <SearchBar />}

        {isWeb3Enabled && (
          <NavBarElementContainer>
            <HollowButtonContainer
              className="flex justify-center items-center "
              onClick={() => setOpen(true)}
            >
              <Close fill="white" className="rotate-45 h-4 w-4" />
              <div className="w-4" />
              Submit
            </HollowButtonContainer>
          </NavBarElementContainer>
        )}
        <NavBarElementContainer style={{ width: "13rem" }}>
          <HollowInputContainer
            className="h-full cursor-pointer"
            style={{ justifyContent: "center" }}
          >
            <Account />
          </HollowInputContainer>
        </NavBarElementContainer>
      </div>
    </div>
  );
};

const NavBarElementContainer = tw.div`w-40 h-14`;
