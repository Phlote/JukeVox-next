import Head from "next/head";
import React from "react";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export const HomeLayout = ({ children }) => {
  return (
    <div className="h-screen  flex flex-col w-full overflow-y-auto	">
      <Head>
        <title>Phlote TCR</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <SubmitSidenav className="absolute bg-red" />

      <NavBar />
      <div className="h-16" />
      <div className="container flex justify-center items-center flex-grow mx-auto">
        {children}
      </div>
    </div>
  );
};
