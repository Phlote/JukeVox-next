import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import { useRouter } from "next/router";
import { useEffect, useRef, useState } from "react";
import { useOnClickOut } from "../hooks/useOnClickOut";
import useEagerConnect from "../hooks/web3/useEagerConnect";
import useMetaMaskOnboarding from "../hooks/web3/useMetaMaskOnboarding";
import { DropdownActions } from "./Dropdowns/DropdownActions";
import { HollowInputContainer } from "./Hollow";
import { useConnectWalletModalOpen } from "./Modals/ConnectWalletModal";
import { ShortenedWallet } from "./ShortenedWallet";

const Account = (props) => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();

  useEagerConnect();

  // manage connecting state for injected connector

  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const [open, setOpen] = useConnectWalletModalOpen();

  const ref = useRef();
  useOnClickOut(ref, () => setDropdownOpen(false));

  const router = useRouter();

  if (error) {
    console.log(error);
    return (
      <HollowInputContainer
        className="h-full"
        style={{ justifyContent: "center" }}
      >
        {`Error: ${error}`}
      </HollowInputContainer>
    );
  }

  if (typeof account !== "string") {
    return (
      // Use the stuff below for the metamask connect button
      // <>

      <HollowInputContainer
        className="cursor-pointer h-full text-white"
        style={{ justifyContent: "center" }}
        onClick={() => setOpen(true)}
      >
        Connect
      </HollowInputContainer>
    );
  }

  return (
    <HollowInputContainer
      ref={ref}
      className="h-full"
      style={{ justifyContent: "center" }}
    >
      <ShortenedWallet wallet={account} />
      <div className="w-2" />
      <Image
        className={dropdownOpen ? "-rotate-90" : "rotate-90"}
        src={"/chevron.svg"}
        onClick={() => setDropdownOpen(!dropdownOpen)}
        alt="dropdown"
        height={16}
        width={16}
      />
      {dropdownOpen && (
        <DropdownActions bottom={-140}>
          <div
            className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center"
            onClick={() => {
              deactivate();
              setDropdownOpen(false);
            }}
          >
            Disconnect
            <div className="w-4" />
            <Image src="/exit.svg" alt={"disconnect"} height={24} width={24} />
          </div>
          <div className="w-4" />
          <div
            onClick={() => {
              router.push("/editprofile");
              setDropdownOpen(false);
            }}
          >
            <div className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center">
              Edit Profile
            </div>
          </div>
          <div className="w-4" />
        </DropdownActions>
      )}
    </HollowInputContainer>
  );
};

export default Account;
