import { useWeb3React } from "@web3-react/core";
import { UserRejectedRequestError } from "@web3-react/injected-connector";
import { atom, useAtom } from "jotai";
import React, { useEffect, useState } from "react";
import useMetaMaskOnboarding from "../../hooks/web3/useMetaMaskOnboarding";
import { Injected, WalletConnect } from "../../utils/connectors";
import { cacheConnector, CachedConnector } from "../../utils/web3";
import { HollowButtonContainer } from "../Hollow";
import { Modal } from "../Modal";

const connectWalletModalOpenAtom = atom<boolean>(false);
export const useConnectWalletModalOpen = () =>
  useAtom(connectWalletModalOpenAtom);

export const ConnectWalletModal = () => {
  const [open, setOpen] = useConnectWalletModalOpen();
  const { account, activate, deactivate } = useWeb3React();

  React.useEffect(() => {
    if (account) setOpen(closed);
  }, [account, setOpen]);

  return (
    <Modal open={open} width="30rem">
      <div className="w-full h-full flex flex-col justify-center items-center text-center">
        <div className="w-3/4">
          <HollowButtonContainer
            className="cursor-pointer"
            onClick={() => {
              activate(WalletConnect).then((res) =>
                cacheConnector(CachedConnector.WalletConnect)
              );
            }}
          >
            Wallet Connect
          </HollowButtonContainer>
          <div className="h-8" />
          <InjectedConnectorButton />
        </div>
      </div>
    </Modal>
  );
};

export const InjectedConnectorButton = () => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();

  const {
    isMetaMaskInstalled,
    isWeb3Available,
    startOnboarding,
    stopOnboarding,
  } = useMetaMaskOnboarding();

  const [connecting, setConnecting] = useState(false);
  useEffect(() => {
    if (active || error) {
      setConnecting(false);
      stopOnboarding();
    }
  }, [active, error, stopOnboarding]);

  if (isWeb3Available) {
    return (
      <HollowButtonContainer
        className="cursor-pointer w-full text-white"
        style={{ justifyContent: "center" }}
        disabled={connecting}
        onClick={() => {
          setConnecting(true);
          activate(Injected, undefined, true)
            .then(() => {
              cacheConnector(CachedConnector.Injected);
            })
            .catch((error) => {
              // ignore the error if it's a user rejected request
              if (error instanceof UserRejectedRequestError) {
                setConnecting(false);
              } else {
                setError(error);
              }
            });
        }}
      >
        Metamask
      </HollowButtonContainer>
    );
  } else
    return (
      <HollowButtonContainer
        className="cursor-pointer w-full justify-center"
        onClick={startOnboarding}
      >
        <a href="https://metamask.io/download/"></a>Install Metamask
      </HollowButtonContainer>
    );
};
