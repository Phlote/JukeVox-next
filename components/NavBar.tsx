import { useWeb3React } from "@web3-react/core";
import Link from "next/link";
import { useRouter } from "next/router";
import tw from "twin.macro";
import { useIsCurator } from "../hooks/useIsCurator";
import useEagerConnect from "../hooks/web3/useEagerConnect";
import Close from "../public/close.svg";
import Account from "./Account";
import { HollowButtonContainer } from "./Hollow";
import { SearchBar } from "./SearchBar";
import { useSubmitSidenavOpen } from "./SideNav";

export const NavBar = () => {
  const triedToEagerConnect = useEagerConnect();
  const [, setOpen] = useSubmitSidenavOpen();
  // const [, setCurations] = useUserCurations();
  const isCurator = useIsCurator();
  const router = useRouter();
  const { active, account, deactivate } = useWeb3React();

  const { NODE_ENV } = process.env;

  const allowCurate = active && isCurator.data && isCurator.data.isCurator;

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
                <HollowButtonContainer className="cursor-pointer flex justify-center items-center ">
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
              <Link href={`/myarchive?wallet=${account}`} passHref>
                <HollowButtonContainer className="cursor-pointer flex justify-center items-center ">
                  My Archive
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

        {allowCurate && NODE_ENV !== "production" && (
          <>
            <NavBarElementContainer>
              <HollowButtonContainer
                className="max-w-xs cursor-pointer flex justify-center items-center"
                onClick={async () => {
                  deactivate();
                }}
              >
                Disconnect Wallet
              </HollowButtonContainer>
            </NavBarElementContainer>
            <div className="w-4" />
          </>
        )}

        {allowCurate && (
          <>
            <NavBarElementContainer>
              <HollowButtonContainer
                className="cursor-pointer flex justify-center items-center"
                onClick={() => setOpen(true)}
              >
                <Close fill="white" className="rotate-45 h-4 w-4" />
                <div className="w-4" />
                Stamp
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
