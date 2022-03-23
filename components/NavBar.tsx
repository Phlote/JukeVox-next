import { useWeb3React } from "@web3-react/core";
import Link from "next/link";
import { useRouter } from "next/router";
import tw from "twin.macro";
import useEagerConnect from "../hooks/web3/useEagerConnect";
import Close from "../public/close.svg";
import Account from "./Account";
import { HollowButtonContainer } from "./Hollow";
import { SearchBar } from "./SearchBar";
import { useSubmitSidenavOpen } from "./SideNav";

export const NavBar = () => {
  const triedToEagerConnect = useEagerConnect();
  const [, setOpen] = useSubmitSidenavOpen();
  const router = useRouter();
  const { active, account, deactivate } = useWeb3React();

  const { NODE_ENV } = process.env;

  return (
    <div className="py-4 flex-none w-screen px-12">
      <div className="relative flex flex-row" style={{ height: 70 }}>
        <Link href="/" passHref>
          <h1 className="text-6xl cursor-pointer">Phlote</h1>
        </Link>

        <div className="flex-grow" />
        <div className="w-4" />

        {active && (
          <>
            <NavBarElementContainer>
              <Link href="/archive" passHref>
                <HollowButtonContainer className="flex justify-center items-center ">
                  Index
                </HollowButtonContainer>
              </Link>
            </NavBarElementContainer>
            <div className="w-4" />
          </>
        )}
        {active && account && (
          <>
            <NavBarElementContainer>
              <Link href={`/profile?wallet=${account}`} passHref>
                <HollowButtonContainer className="flex justify-center items-center ">
                  My Profile
                </HollowButtonContainer>
              </Link>
            </NavBarElementContainer>
            <div className="w-4" />
          </>
        )}

        {router.pathname !== "/" && (
          <>
            <SearchBar />
            <div className="w-4" />
          </>
        )}

        {NODE_ENV !== "production" && (
          <>
            <NavBarElementContainer>
              <HollowButtonContainer
                className="max-w-xs flex justify-center items-center"
                onClick={deactivate}
              >
                Disconnect Wallet
              </HollowButtonContainer>
            </NavBarElementContainer>
            <div className="w-4" />
          </>
        )}

        {active && (
          <>
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
            <div className="w-4" />
          </>
        )}
        <NavBarElementContainer style={{ width: "13rem" }}>
          <Account triedToEagerConnect={triedToEagerConnect} />
        </NavBarElementContainer>
      </div>
    </div>
  );
};

const NavBarElementContainer = tw.div`w-40 h-16`;
