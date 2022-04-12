import { useWeb3React } from "@web3-react/core";
import { useEffect, useState } from "react";
import { Injected, WalletConnect } from "../../utils/connectors";
import { CachedConnector, getCachedConnector } from "../../utils/web3";

export default function useEagerConnect() {
  const { activate, active } = useWeb3React();

  const [tried, setTried] = useState(false);

  const cachedConnector = getCachedConnector();

  useEffect(() => {
    if (!tried && !active && cachedConnector) {
      if (cachedConnector === CachedConnector.Injected) {
        Injected.isAuthorized().then((isAuthorized) => {
          if (isAuthorized)
            activate(Injected, undefined, true).catch(() => {
              setTried(true);
            });
        });
      } else if (cachedConnector === CachedConnector.WalletConnect) {
        activate(WalletConnect, undefined, true).catch(() => {
          setTried(true);
        });
      }
    }
  }, [activate, tried, active, cachedConnector]);

  // if the connection worked, wait until we get confirmation of that to flip the flag
  useEffect(() => {
    if (!tried && active) {
      setTried(true);
    }
  }, [tried, active]);

  return tried;
}
