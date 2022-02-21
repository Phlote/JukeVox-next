import Head from "next/head";
import React from "react";
import { useOnWalletDisconnect } from "./Account";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export const HomeLayout = ({ children }) => {
  useOnWalletDisconnect();

  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <Head>
        <title>Phlote TCR</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <SubmitSidenav />

      <NavBar />
      <div className="container flex justify-center items-center flex-grow mx-auto max-h-max">
        {children}
      </div>
    </div>
  );
};
