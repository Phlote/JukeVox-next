import Head from "next/head";
import React from "react";
import useOnWalletDisconnect from "../hooks/web3/useOnWalletDisconnect";
import { Footer } from "./Footer";
import { RinkebyPromptModal } from "./Modal";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export const HomeLayout: React.FC = ({ children }) => {
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
      <div className="container flex justify-center mx-auto max-h-max items-center flex-grow">
        {children}
      </div>
      <Footer />
    </div>
  );
};

interface ArchiveLayoutProps {
  center?: boolean;
}

export const ArchiveLayout: React.FC<ArchiveLayoutProps> = ({
  children,
  center,
}) => {
  return (
    <div className="h-screen flex flex-col w-full overflow-y-auto">
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
        className="container flex justify-center mx-auto flex-grow"
        style={center ? { alignItems: "center", flexGrow: 1 } : undefined}
      >
        {children}
      </div>
    </div>
  );
};
