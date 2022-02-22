import Head from "next/head";
import React from "react";
import useOnWalletDisconnect from "../hooks/useOnWalletDisconnect";
import { RinkebyPromptModal } from "./Modal";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

interface DefaultLayoutProps {
  center?: boolean;
}

export const DefaultLayout: React.FC<DefaultLayoutProps> = ({
  children,
  center,
}) => {
  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <Head>
        <title>Phlote Search</title>
        <link rel="icon" href="/favicon.svg" type="image/svg+xml" />
        {/* TODO edit this png to be a square */}
        <link rel="icon" type="image/png" href="/favicon.png" />
        <link rel="icon" href="/favicon.ico" sizes="any" />
      </Head>
      <SubmitSidenav />
      <RinkebyPromptModal />

      <NavBar />
      <div
        className="container flex justify-center mx-auto max-h-max"
        style={center ? { alignItems: "center", flexGrow: 1 } : undefined}
      >
        {children}
      </div>
    </div>
  );
};
