import { useWeb3React } from "@web3-react/core";
import { UserRejectedRequestError } from "@web3-react/injected-connector";
import { useEffect, useState } from "react";
import { injected } from "../connectors";
import useENSName from "../hooks/useENSName";
import useMetaMaskOnboarding from "../hooks/useMetaMaskOnboarding";
import { formatEtherscanLink, shortenHex } from "../util";

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
          <button
            className="p-4 rounded-xl w-64 h-16 justify-center items-center"
            style={{
              backgroundColor: "#E4E4E4",
            }}
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
            {/* text-white text-xl leading-6 */}
            <p className="text-white m-0 font-extrabold text-xl leading-7 ">
              Connect to curate
            </p>
          </button>
        ) : (
          <button onClick={startOnboarding}>Install a Wallet</button>
        )}
      </div>
    );
  }

  return (
    <div
      className="p-4 rounded-xl w-64 h-16 flex justify-center items-center"
      style={{
        backgroundColor: "#E4E4E4",
      }}
    >
      {ENSName || `${shortenHex(account, 10)}`}
    </div>
  );
};

export default Account;
