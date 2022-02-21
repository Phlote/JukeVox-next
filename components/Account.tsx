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
    return null;
  }

  if (!triedToEagerConnect) {
    return null;
  }

  if (typeof account !== "string") {
    return (
      <div>
        {isWeb3Available ? (
          <HollowInputContainer
            className="cursor-pointer h-full"
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
            <p className="text-white text-xl">Connect to curate</p>
          </HollowInputContainer>
        ) : (
          <HollowInputContainer
            className="cursor-pointer h-full"
            onClick={startOnboarding}
          >
            <a href="https://metamask.io/download/"></a>Install Metamask
          </HollowInputContainer>
        )}
      </div>
    );
  }

  return (
    <HollowInputContainer
      className="justify-center h-full"
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
