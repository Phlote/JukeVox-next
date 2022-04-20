import { useWeb3React } from "@web3-react/core";
import Link from "next/link";
import { useRouter } from "next/router";
import tw from "twin.macro";
import { useIsCurator } from "../hooks/useIsCurator";
import Close from "../public/close.svg";
import Account from "./Account";
import { useSubmissionFlowOpen } from "./CurationSubmissionFlow";
import { HollowButtonContainer, HollowInputContainer } from "./Hollow";
import { SearchBar } from "./SearchBar";

export const NavBarMobileWeb = () => {
  const [, setOpen] = useSubmissionFlowOpen();
  const router = useRouter();
  const { active, account } = useWeb3React();
  const isCurator = useIsCurator();
  return (
    <div className="w-screen flex flex-row flex-none bg-phlote-container divide-x ">
      {/* {active && (
        <MobileNavBarElementContainer>
          <Link href="/archive" passHref>
            Index
          </Link>
        </MobileNavBarElementContainer>
      )}*/}
      {/* {active && account && isCurator && (
        <MobileNavBarElementContainer>
          <Link href={`/profile?wallet=${account}`} passHref>
            My Profile
          </Link>
        </MobileNavBarElementContainer>
      )} */}
      {active && (
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
