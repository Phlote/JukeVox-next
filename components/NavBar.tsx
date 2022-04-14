import { useWeb3React } from "@web3-react/core";
import Link from "next/link";
import { useRouter } from "next/router";
import tw from "twin.macro";
import { useIsCurator } from "../hooks/useIsCurator";
import Close from "../public/close.svg";
import Account from "./Account";
import { HollowButtonContainer } from "./Hollow";
import { SearchBar } from "./SearchBar";
import { useSubmitSidenavOpen } from "./SideNav";

const NavBarMobileWeb = () => {
  return (
    <div className="w-screen grid grid-cols-4 absolute bottom-0  bg-phlote-container divide-x">
      <MobileNavBarElementContainer>Index</MobileNavBarElementContainer>
      <MobileNavBarElementContainer>My Profile</MobileNavBarElementContainer>
      <MobileNavBarElementContainer>Submit</MobileNavBarElementContainer>
      <MobileNavBarElementContainer>Account</MobileNavBarElementContainer>
    </div>
  );
};

const MobileNavBarElementContainer = tw.div`h-full w-full py-8 text-center`;

const NavBarDesktop = (props) => {
  const [, setOpen] = useSubmitSidenavOpen();
  const router = useRouter();
  const { active, account } = useWeb3React();
  const isCurator = useIsCurator();
  return (
    <div className="py-4 flex-none w-screen px-12">
      <div className="relative flex flex-row gap-4" style={{ height: 70 }}>
        <Link href="/" passHref>
          <h1 className="text-6xl cursor-pointer">Phlote</h1>
        </Link>
        <div className="flex-grow" />
        {active && (
          <NavBarElementContainer>
            <Link href="/archive" passHref>
              <HollowButtonContainer className="flex justify-center items-center ">
                Index
              </HollowButtonContainer>
            </Link>
          </NavBarElementContainer>
        )}
        {active && account && isCurator && (
          <NavBarElementContainer>
            <Link href={`/profile?wallet=${account}`} passHref>
              <HollowButtonContainer className="flex justify-center items-center ">
                My Profile
              </HollowButtonContainer>
            </Link>
          </NavBarElementContainer>
        )}
        {router.pathname == "/archive" && <SearchBar />}

        {active && (
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
          <Account />
        </NavBarElementContainer>
      </div>
    </div>
  );
};

export const NavBar = () => {
  return (
    <>
      <div className="hidden sm:flex">
        <NavBarDesktop />
      </div>
      <div className="sm:hidden ">
        <NavBarMobileWeb />
      </div>
    </>
  );
};

const NavBarElementContainer = tw.div`w-40 h-14`;
