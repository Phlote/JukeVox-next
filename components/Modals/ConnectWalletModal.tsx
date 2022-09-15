import { UnsupportedChainIdError, useWeb3React } from "@web3-react/core";
import { UserRejectedRequestError } from "@web3-react/injected-connector";
import { atom, useAtom } from "jotai";
import Image from "next/image";
import React, { useEffect, useState } from "react";
import useMetaMaskOnboarding from "../../hooks/web3/useMetaMaskOnboarding";
import { Injected, WalletConnect } from "../../utils/connectors";
import { cacheConnector, CachedConnector } from "../../utils/web3";
import { HollowButtonContainer } from "../Hollow";
import { Modal } from "../Modal";
import { useRouter } from "next/router";
import { getProfile } from "../../controllers/profiles";

const connectWalletModalOpenAtom = atom<boolean>(false);
export const useConnectWalletModalOpen = () =>
  useAtom(connectWalletModalOpenAtom);

export const ConnectWalletModal = () => {
  const [open, setOpen] = useConnectWalletModalOpen();
  const { account, activate, deactivate, chainId, active, error } =
    useWeb3React();

  const isUnsupportedChainId = error instanceof UnsupportedChainIdError;

  React.useEffect(() => {
    if (isUnsupportedChainId) setOpen(true);
  }, [isUnsupportedChainId, setOpen]);

  const onClose = () => setOpen(false);

  return (
    <Modal open={open} onClose={onClose} width="24rem" height="24rem">
      <div className="w-full h-full flex flex-col  items-center text-center">
        {/* <p className="mt-8">
          Make sure you are connected with the{" "}
          <a
            className="underline"
            href={
              "https://docs.polygon.technology/docs/develop/metamask/config-polygon-on-metamask#polygon-scan"
            }
          >
            Polygon
          </a>{" "}
          network to save on gas!
        </p> */}
        <div className="flex-grow w-full flex justify-center items-center">
          <div className="w-3/4 grid grid-cols-1 gap-4">
            <WalletConnectButton setOpen={setOpen} />
            <div className="sm:block hidden">
              <InjectedConnectorButton setOpen={setOpen} />
            </div>

            {isUnsupportedChainId && (
              <p className="text-red-500">
                {
                  "Your wallet is connected to the wrong network, please connect it to Polygon"
                }
              </p>
            )}
          </div>
        </div>
      </div>
    </Modal>
  );
};

// TODO: These components are almost duplicates, create a more general component that can be extended

export const WalletConnectButton = ({setOpen}) => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();
  const router = useRouter();

  const [connecting, setConnecting] = useState(false);
  useEffect(() => {
    if (active || error) {
      setConnecting(false);
    }
  }, [active, error]);

  useEffect(() => {
    if (account && connecting) {
      setOpen(false);
      getProfile(account)
        .then((profile) => {
          if (!router.pathname.includes('archive'))
            // console.log("SEND");
            router.push("/archive");
        })
        .catch(error => {
          // console.log("ERROR: ", error);
          router.push("/editprofile");
        });
    }
    // TODO: Do this instead only when user is interacting with the connect wallet modal
  }, [account, setOpen]);

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
            console.error("this error: ", error);
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

export const InjectedConnectorButton = ({setOpen}) => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();
  const router = useRouter();

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

  useEffect(() => {
    if (account && connecting) {
      setOpen(false);
      getProfile(account)
        .then((profile) => {
          if (!router.pathname.includes('archive'))
            // console.log("SEND");
            router.push("/archive");
        })
        .catch(error => {
          // console.log("ERROR: ", error);
          router.push("/editprofile");
        });
    }
    // TODO: Do this instead only when user is interacting with the connect wallet modal
  }, [account, setOpen]);

  if (isWeb3Available) {
    return (
      <HollowButtonContainer
        className="w-full"
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
      <a href="https://metamask.io/download/">
        <HollowButtonContainer className="w-full" onClick={startOnboarding}>
          <InjectedButtonContent />
        </HollowButtonContainer>
      </a>
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
