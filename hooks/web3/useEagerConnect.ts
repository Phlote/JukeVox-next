import { useWeb3React } from "@web3-react/core";
import { useEffect, useState } from "react";
import { Injected, WalletConnect } from "../../utils/connectors";

export default function useEagerConnect() {
  const { activate, active } = useWeb3React();

  const [tried, setTried] = useState(false);

  useEffect(() => {
    if (!tried && !active)
      Injected.isAuthorized().then((isAuthorized) => {
        if (isAuthorized) {
          activate(Injected, undefined, true).catch(() => {
            setTried(true);
          });
        } else {
          // if injected isn't authorized, try wallet connect
          activate(WalletConnect, undefined, true).catch(() => {
            setTried(true);
          });
        }
      });
  }, [activate, tried, active]);

  // if the connection worked, wait until we get confirmation of that to flip the flag
  useEffect(() => {
    if (!tried && active) {
      setTried(true);
    }
  }, [tried, active]);

  return tried;
}
