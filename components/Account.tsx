import { useWeb3React } from "@web3-react/core";
import { UserRejectedRequestError } from "@web3-react/injected-connector";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { injected } from "../connectors";
import useENSName from "../hooks/useENSName";
import useMetaMaskOnboarding from "../hooks/useMetaMaskOnboarding";
import { formatEtherscanLink, shortenHex } from "../util";
import { HollowButtonContainer, HollowInputContainer } from "./Hollow";

type AccountProps = {
  triedToEagerConnect: boolean;
};

const Account = ({ triedToEagerConnect }: AccountProps) => {
  const { active, error, activate, chainId, account, setError } =
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

  const ENSName = useENSName(account);

  if (error) {
    console.log(error);
    return (
      <HollowInputContainer
        className="h-full"
        style={{ justifyContent: "center" }}
      >
        {"Check Metamask"}
      </HollowInputContainer>
    );
  }

  if (!triedToEagerConnect) {
    return null;
  }

  if (typeof account !== "string") {
    return (
      <>
        {isWeb3Available ? (
          <HollowInputContainer
            className="cursor-pointer h-full text-white"
            style={{ justifyContent: "center" }}
            disabled={connecting}
            onClick={() => {
              setConnecting(true);

              activate(injected, undefined, true).catch((error) => {
                // ignore the error if it's a user rejected request
                if (error instanceof UserRejectedRequestError) {
                  setConnecting(false);
                } else {
                  setError(error);
                }
              });
            }}
          >
            Connect to Wallet
          </HollowInputContainer>
        ) : (
          <HollowInputContainer
            className="cursor-pointer h-full justify-center"
            onClick={startOnboarding}
          >
            <a href="https://metamask.io/download/"></a>Install Metamask
          </HollowInputContainer>
        )}
      </>
    );
  }

  return (
    <HollowInputContainer
      className="h-full"
      style={{ justifyContent: "center" }}
    >
      {ENSName || `${shortenHex(account, 5)}`}
    </HollowInputContainer>
  );
};

export const useShortenedWallet = (account: string) => {
  const ENSName = useENSName(account);
  return ENSName || `${shortenHex(account, 5)}`;
};

export default Account;
