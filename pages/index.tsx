import { useWeb3React } from "@web3-react/core";
import Head from "next/head";
import Link from "next/link";
import React, { useState } from "react";
import Account from "../components/Account";

import ETHBalance from "../components/ETHBalance";
import { NavBar } from "../components/NavBar";
import TokenBalance from "../components/TokenBalance";
import useEagerConnect from "../hooks/useEagerConnect";
import { useIsCurator } from "../hooks/useIsCurator";
import { changeNetwork } from "../util";
import Image from "next/image";
import { LineInput, LineInputContainer } from "../components/LineInput";
import { POLYGON_CHAIN_ID } from "../constants";
import { HollowInput, HollowInputContainer } from "../components/HollowInput";
import { atom, useAtom } from "jotai";
import { DefaultLayout } from "../components/DefaultLayout";

const curationSubmissionOpenAtom = atom<boolean>(false);
export const useCurationSubmissionOpen = () =>
  useAtom(curationSubmissionOpenAtom);

function Home() {
  const [open, setOpen] = useCurationSubmissionOpen();
  return (
    <DefaultLayout>
      <Head>
        <title>Phlote TCR</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <NavBar />

      <div className="container flex justify-center items-center flex-grow mx-auto">
        <div className="w-3/4 h-16" style={{ lineHeight: "0.5rem" }}>
          <HollowInputContainer
            onClick={() => {
              document.getElementById("search-home").focus();
            }}
          >
            <Image height={30} width={30} src="/search.svg" alt="search" />
            <HollowInput
              id="search-home"
              className="ml-4 flex-grow"
              type="text"
              placeholder="Artist Name"
            />
          </HollowInputContainer>
        </div>
      </div>
    </DefaultLayout>
  );
}

export default Home;
