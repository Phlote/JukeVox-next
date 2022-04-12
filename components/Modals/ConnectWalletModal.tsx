import { useWeb3React } from "@web3-react/core";
import { UserRejectedRequestError } from "@web3-react/injected-connector";
import { atom, useAtom } from "jotai";
import Image from "next/image";
import React, { useEffect, useState } from "react";
import useMetaMaskOnboarding from "../../hooks/web3/useMetaMaskOnboarding";
import { Injected, WalletConnect } from "../../utils/connectors";
import { cacheConnector, CachedConnector } from "../../utils/web3";
import { HollowButtonContainer } from "../Hollow";
import { Modal } from "../Modal";

const connectWalletModalOpenAtom = atom<boolean>(true);
export const useConnectWalletModalOpen = () =>
  useAtom(connectWalletModalOpenAtom);

export const ConnectWalletModal = () => {
  const [open, setOpen] = useConnectWalletModalOpen();
  const { account, activate, deactivate } = useWeb3React();

  React.useEffect(() => {
    if (account) setOpen(closed);
  }, [account, setOpen]);

  return (
    <Modal open={open} width="24rem" height="24rem">
      <div className="w-full h-full flex flex-col justify-center items-center text-center">
        <div className="w-3/4">
          <WalletConnectButton />
          <div className="h-4" />
          <InjectedConnectorButton />
        </div>
      </div>
    </Modal>
  );
};

export const WalletConnectButton = () => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();

  const [connecting, setConnecting] = useState(false);
  useEffect(() => {
    if (active || error) {
      setConnecting(false);
    }
  }, [active, error]);

  return (
    <HollowButtonContainer
      disabled={connecting}
      onClick={() => {
        setConnecting(true);
        activate(WalletConnect, undefined, true)
          .then(() => {
            cacheConnector(CachedConnector.WalletConnect);
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
      <div className="flex flex-row w-full justify-left items-center">
        <Image
          src="/walletconnect.svg"
          height={32}
          width={32}
          alt={"WalletConnect"}
        />
        <div className="w-2" />
        WalletConnect
      </div>
    </HollowButtonContainer>
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
        <InjectedButtonContent />
      </HollowButtonContainer>
    );
  } else
    return (
      <HollowButtonContainer
        className="cursor-pointer w-full justify-center"
        onClick={startOnboarding}
      >
        <a href="https://metamask.io/download/"></a>
        <InjectedButtonContent />
      </HollowButtonContainer>
    );
};

const InjectedButtonContent = () => {
  return (
    <div className="flex flex-row w-full justify-left items-center">
      <Image src="/metamask.svg" height={32} width={32} alt={"Metamask"} />
      <div className="w-2" />
      Metamask
    </div>
  );
};
