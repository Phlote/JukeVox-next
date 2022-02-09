import Head from "next/head";
import React from "react";
import { NavBar } from "./NavBar";

export const DefaultLayout = ({ children }) => {
  return (
    <div className="h-screen flex flex-col w-full">
      <Head>
        <title>Phlote TCR</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <NavBar />
      <div className="container flex justify-center items-center flex-grow mx-auto">
        {children}
      </div>
    </div>
  );
};
