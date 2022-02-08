import Link from "next/link";
import useEagerConnect from "../hooks/useEagerConnect";
import Account from "./Account";
import Image from "next/image";
import { useWeb3React } from "@web3-react/core";
import { useState } from "react";
import { useIsCurator } from "../hooks/useIsCurator";
import { POLYGON_CHAIN_ID } from "../constants";
import { changeNetwork } from "../util";
import { HollowInputContainer } from "./HollowInput";
import { CuratorSubmissionModal } from "./CuratorSubmissionModal";
import { useCurationSubmissionOpen } from "../pages";

export const NavBar = () => {
  const triedToEagerConnect = useEagerConnect();
  const [, setModalOpen] = useCurationSubmissionOpen();

  const { account, library, chainId, activate, deactivate } = useWeb3React();

  const [error, setError] = useState<string>();

  const isConnected = typeof account === "string" && !!library;

  const isCurator = useIsCurator();

  const onNetworkSwitch = async (networkName) => {
    await changeNetwork(networkName, setError);
  };

  return (
    <div className="py-4 absolute w-full px-12">
      <div className="relative flex flex-row" style={{ height: 70 }}>
        <h1 className="text-6xl">Phlote</h1>
        <div className="flex-grow" />

        <div className="w-4" />

        <div
          className="rounded-full  cursor-pointer flex justify-center items-center h-16 w-16"
          style={{
            backgroundColor: "rgba(228, 228, 228, 0.37)",
          }}
        >
          <Image
            src="/app-drawer.svg"
            alt="app-drawer"
            height={32}
            width={32}
          ></Image>
        </div>

        <div className="w-4" />

        <Account triedToEagerConnect={triedToEagerConnect} />

        <div className="w-4" />

        {isConnected && (
          <HollowInputContainer
            className=" cursor-pointer flex justify-center items-center h-16"
            onClick={() => deactivate()}
          >
            Disconnect Wallet
          </HollowInputContainer>
        )}

        <div className="w-4" />

        {isConnected && chainId !== POLYGON_CHAIN_ID && (
          <HollowInputContainer
            className="cursor-pointer flex justify-center items-center h-16"
            onClick={() => onNetworkSwitch("polygon")}
          >
            Switch to Polygon
          </HollowInputContainer>
        )}

        {isConnected && isCurator && (
          <HollowInputContainer
            className="cursor-pointer flex justify-center items-center h-16"
            onClick={() => setModalOpen(true)}
          >
            Submit Curation
          </HollowInputContainer>
        )}
      </div>
    </div>
  );
};
