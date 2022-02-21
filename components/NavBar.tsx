import useEagerConnect from "../hooks/useEagerConnect";
import Account from "./Account";
import { useWeb3React } from "@web3-react/core";
import { useState } from "react";
import { useIsCurator } from "../hooks/useIsCurator";
import { changeNetwork } from "../util";
import { HollowButtonContainer } from "./Hollow";
import Link from "next/link";
import { useSubmitSidenavOpen } from "./SideNav";
import { useRouter } from "next/router";
import { useUserCurations } from "../pages/myarchive";

export const NavBar = () => {
  const triedToEagerConnect = useEagerConnect();
  const [, setOpen] = useSubmitSidenavOpen();
  const [, setCurations] = useUserCurations();

  const { account, library, deactivate, active } = useWeb3React();

  return (
    <div className="py-4 absolute w-screen px-12">
      <div className="relative flex flex-row" style={{ height: 70 }}>
        <Link href="/" passHref>
          <h1 className="text-6xl cursor-pointer">Phlote</h1>
        </Link>

        <div className="flex-grow" />
        <div className="w-4" />
        {/* <div
          className="rounded-full cursor-pointer flex justify-center items-center h-16 w-16"
          style={{
            backgroundColor: "rgba(242, 244, 248, 0.17)",
          }}
        >
          <Image
            src="/app-drawer.svg"
            alt="app-drawer"
            height={32}
            width={32}
          ></Image>
        </div> */}

        {active && (
          <>
            <Link href="/myarchive" passHref>
              <HollowButtonContainer className=" max-w-xs cursor-pointer flex justify-center items-center h-16">
                My Archive
              </HollowButtonContainer>
            </Link>

            <div className="w-4" />
          </>
        )}

        {active && (
          <>
            <HollowButtonContainer
              className="max-w-xs cursor-pointer flex justify-center items-center h-16"
              onClick={async () => {
                deactivate();
                setCurations([]);
              }}
            >
              Disconnect Wallet
            </HollowButtonContainer>
            <div className="w-4" />
          </>
        )}

        {active && (
          <>
            <HollowButtonContainer
              className=" max-w-xs cursor-pointer flex justify-center items-center h-16"
              onClick={() => setOpen(true)}
            >
              Submit
            </HollowButtonContainer>
            <div className="w-4" />
          </>
        )}

        <Account triedToEagerConnect={triedToEagerConnect} />
      </div>
    </div>
  );
};
