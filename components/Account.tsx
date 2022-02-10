import { useWeb3React } from "@web3-react/core";
import { UserRejectedRequestError } from "@web3-react/injected-connector";
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
          <HollowButtonContainer
            style={{ backgroundColor: "rgba(228, 228, 228, 0.37)" }}
            className="cursor-pointer h-16"
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
          </HollowButtonContainer>
        ) : (
          <HollowButtonContainer
            style={{ backgroundColor: "rgba(228, 228, 228, 0.37)" }}
            className="cursor-pointer h-16"
            onClick={startOnboarding}
          >
            Install a Wallet
          </HollowButtonContainer>
        )}
      </div>
    );
  }

  return (
    <HollowButtonContainer
      className="h-16 max-w-xs"
      style={{ backgroundColor: "rgba(228, 228, 228, 0.37)" }}
    >
      {ENSName || `${shortenHex(account, 10)}`}
    </HollowButtonContainer>
  );
};

export default Account;
