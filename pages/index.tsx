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
import TokenBalance from "../components/TokenBalance";
import useEagerConnect from "../hooks/useEagerConnect";
import { useIsCurator } from "../hooks/useIsCurator";
import { changeNetwork } from "../util";

const DAI_TOKEN_ADDRESS = "0x6b175474e89094c44da98b954eedeac495271d0f";

function Home() {
  const { account, library, chainId, activate } = useWeb3React();
  const triedToEagerConnect = useEagerConnect();

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
        <nav>
          <Link href="/">
            <a>next-web3-boilerplate</a>
          </Link>

          <Account triedToEagerConnect={triedToEagerConnect} />
        </nav>
      </header>

      <div className="container mx-auto flex justify-center items-center flex-col">
        <h1>
          Welcome to <a href="https://twitter.com/teamphlote">Phlote TCR!</a>
        </h1>

        {isConnected && (
          <section>
            <ETHBalance />
            <TokenBalance tokenAddress={DAI_TOKEN_ADDRESS} symbol="DAI" />
            <p className="text-red">{error}</p>

            <div className="m-2 flex flex-row justify-center">
              <button
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                onClick={() => onNetworkSwitch("polygon")}
              >
                Switch to Polygon
              </button>
            </div>

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

        <div className="h-4"></div>
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
