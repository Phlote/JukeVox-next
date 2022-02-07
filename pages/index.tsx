import { useWeb3React } from "@web3-react/core";
import Head from "next/head";
import Link from "next/link";
import React, { useState } from "react";
import Account from "../components/Account";
import {
  CurationMetadata,
  CuratorSubmissionModal,
} from "../components/CuratorSubmissionModal";
import ETHBalance from "../components/ETHBalance";
import { NavBar } from "../components/NavBar";
import TokenBalance from "../components/TokenBalance";
import useEagerConnect from "../hooks/useEagerConnect";
import { useIsCurator } from "../hooks/useIsCurator";
import { changeNetwork } from "../util";
import Image from "next/image";
import { LineInput, LineInputContainer } from "../components/LineInput";
import { POLYGON_CHAIN_ID } from "../constants";
import {
  HollowInput,
  HollowInputContainer,
  HollowInputOverlay,
} from "../components/HollowInput";

const DAI_TOKEN_ADDRESS = "0x6b175474e89094c44da98b954eedeac495271d0f";

function Home() {
  const { account, library, chainId, activate } = useWeb3React();

  const [error, setError] = useState<string>();

  const isConnected = typeof account === "string" && !!library;

  const isCurator = useIsCurator();

  // network switch
  const onNetworkSwitch = async (networkName) => {
    await changeNetwork(networkName, setError);
  };

  const [submissionModalOpen, setsubmissionModalOpen] =
    useState<boolean>(false);

  return (
    <div className="h-screen flex flex-col w-full">
      <Head>
        <title>Phlote TCR</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <NavBar />

      <div className="container flex justify-center items-center flex-grow mx-auto">
        {isConnected && (
          <section>
            {/* <ETHBalance />
            <TokenBalance tokenAddress={DAI_TOKEN_ADDRESS} symbol="DAI" /> */}
            <p className="text-red">{error}</p>

            {chainId !== POLYGON_CHAIN_ID && (
              <div className="m-2 flex flex-row justify-center">
                <button
                  className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                  onClick={() => onNetworkSwitch("polygon")}
                >
                  Switch to Polygon
                </button>
              </div>
            )}

            {isCurator && (
              <div className="m-2 flex flex-row justify-center">
                <button
                  className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                  onClick={() => setsubmissionModalOpen(true)}
                >
                  Submit Curation
                </button>
              </div>
            )}
            <CuratorSubmissionModal
              open={submissionModalOpen}
              setOpen={setsubmissionModalOpen}
            />
          </section>
        )}

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
    </div>
  );
}

export default Home;
