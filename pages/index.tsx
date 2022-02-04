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
    <div>
      <Head>
        <title>Phlote TCR</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <header>
        <NavBar />
      </header>

      <div className="container flex justify-center items-center flex-col">
        <div className="h-20"></div>
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

            {/* {isCurator && (
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
            /> */}
          </section>
        )}
      </div>
      <div
        className="flex justify-start flex-col mx-12"
        style={{ lineHeight: "2rem" }}
      >
        <h1 className="font-extrabold text-4xl">
          {" "}
          Web3 Search Engine powered by a community
        </h1>
        <br />
        <h2 className="text-3xl	font-normal">
          {" "}
          that exists to elevate the art of curation.
        </h2>
        <div className="h-6" />
        <div className="w-3/4">
          <LineInputContainer secondary="white">
            <Image height={30} width={30} src="/search.svg" alt="search" />
            <LineInput
              secondary="white"
              className="ml-4 flex-grow"
              type="text"
              placeholder="Search"
            />
          </LineInputContainer>
        </div>
      </div>

      <style jsx>{`
        nav {
          display: flex;
          justify-content: space-between;
        }

        main {
          text-align: center;
        }
      `}</style>
    </div>
  );
}

export default Home;
