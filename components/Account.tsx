import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import { useEffect, useRef, useState } from "react";
import { useOnCopy } from "../hooks/useOnCopy";
import useENSName from "../hooks/web3/useENSName";
import useMetaMaskOnboarding from "../hooks/web3/useMetaMaskOnboarding";
import { shortenHex } from "../utils/web3";
import { DropdownActions } from "./Dropdowns/DropdownActions";
import { HollowInputContainer } from "./Hollow";
import { useConnectWalletModalOpen } from "./Modals/ConnectWalletModal";

type AccountProps = {
  triedToEagerConnect: boolean;
};

const Account = ({ triedToEagerConnect }: AccountProps) => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();

  const {
    isMetaMaskInstalled,
    isWeb3Available,
    startOnboarding,
    stopOnboarding,
  } = useMetaMaskOnboarding();

  // manage connecting state for injected connector
  const [connecting, setConnecting] = useState(false);
  useEffect(() => {
    if (active || error) {
      setConnecting(false);
      stopOnboarding();
    }
  }, [active, error, stopOnboarding]);

  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const [open, setOpen] = useConnectWalletModalOpen();

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

  if (!triedToEagerConnect) {
    return null;
  }

  if (typeof account !== "string") {
    return (
      // Use the stuff below for the metamask connect button
      // <>
      //   {isWeb3Available ? (
      //     <HollowInputContainer
      //       className="cursor-pointer h-full text-white"
      //       style={{ justifyContent: "center" }}
      //       disabled={connecting}
      //       onClick={() => {
      //         setConnecting(true);
      //         activate(injected, undefined, true).catch((error) => {
      //           // ignore the error if it's a user rejected request
      //           if (error instanceof UserRejectedRequestError) {
      //             setConnecting(false);
      //           } else {
      //             setError(error);
      //           }
      //         });
      //       }}
      //     >
      //       Connect Wallet
      //     </HollowInputContainer>
      //   ) : (
      //     <HollowInputContainer
      //       className="cursor-pointer h-full justify-center"
      //       onClick={startOnboarding}
      //     >
      //       <a href="https://metamask.io/download/"></a>Install Metamask
      //     </HollowInputContainer>
      //   )}
      // </>
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
        <DropdownActions bottom={-80}>
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
        </DropdownActions>
      )}
    </HollowInputContainer>
  );
};

export const ShortenedWallet: React.FC<{ wallet: string }> = ({ wallet }) => {
  const ENSName = useENSName(wallet);
  const ref = useRef();
  useOnCopy(ref, wallet);
  return <span ref={ref}>{ENSName || `${shortenHex(wallet, 5)}`}</span>;
};

export default Account;
