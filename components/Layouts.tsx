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
  useOnWalletDisconnect();

  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <Head>
        <title>Phlote TCR</title>
        <link rel="icon" href="/favicon.ico" />
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
