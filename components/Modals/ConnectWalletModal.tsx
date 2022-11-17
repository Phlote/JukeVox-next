import { atom, useAtom } from "jotai";
import Image from "next/image";
import React, { useEffect } from "react";
import useMetaMaskOnboarding from "../../hooks/web3/useMetaMaskOnboarding";
import { WalletConnect } from "../../utils/connectors";
import { HollowButtonContainer } from "../Hollow";
import { Modal } from "../Modal";
import { useRouter } from "next/router";
import { getProfile } from "../../controllers/profiles";
import { useMoralis } from "react-moralis";
import { UnsupportedChainIdError } from "@web3-react/core";
import { toast } from "react-toastify";
import { revalidate } from "../../controllers/revalidate";

const connectWalletModalOpenAtom = atom<boolean>(false);
export const useConnectWalletModalOpen = () => useAtom(connectWalletModalOpenAtom);

export const ConnectWalletModal = () => {
  const [open, setOpen] = useConnectWalletModalOpen();
  const { hasAuthError, authError, enableWeb3, chainId } = useMoralis();

  const isUnsupportedChainId = authError instanceof UnsupportedChainIdError;
  // TODO: Throw error for unsupported blockchains?
  // If not connected to ChainId 80001 (Testnet polygon) throw this error

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
            <ConnectWalletButtons setOpen={setOpen} />
          </div>
        </div>
      </div>
    </Modal>
  );
};

export const ConnectWalletButtons = ({ setOpen }) => {
  const { authenticate, isWeb3Enabled, isAuthenticating, user, account } = useMoralis();

  const {
    isMetaMaskInstalled,
    isWeb3Available,
    startOnboarding,
    stopOnboarding,
  } = useMetaMaskOnboarding();

  const router = useRouter();

  useEffect(() => {
    if (isWeb3Enabled) {
      setOpen(false);
    }
  }, [isWeb3Enabled, setOpen]);

  useEffect(() => {
    if (account && !isAuthenticating && isWeb3Enabled) {
      getProfile(account)
        .then(profile => {
          if (!router.pathname.includes('archive'))
            router.push("/archive");
        })
        .catch(error => {
          router.push("/editprofile");
        });
    }
  }, [account, isWeb3Enabled, isAuthenticating]);

  const login = async (provider) => {
    if (!isWeb3Enabled) {
      await authenticate({ signingMessage: "Log in using Moralis", provider: provider, chainId: 80001 })
        .then((user) => {
          console.log("logged in user:", user);
          console.log(user!.get("ethAddress"));
          revalidate(account);
        })
        .catch((error) => {
          toast.error(error);
          console.log(error);
        });
    }
  }

  if (!isWeb3Available) {
    return <MetamaskOnboarding {...{ startOnboarding }} />
  }

  return (
    <>
      <HollowButtonContainer
        disabled={isAuthenticating}
        onClick={login}
      >
        <MetamaskButton />
      </HollowButtonContainer>
      <HollowButtonContainer
        disabled={isAuthenticating}
        onClick={() => login("walletconnect")}
      >
        <WalletConnectButton />
      </HollowButtonContainer>
    </>

  );
};

const MetamaskButton = () => {
  return (
    <div className="flex flex-row w-full justify-left items-center">
      <Image src="/metamask.svg" height={32} width={32} alt={"Metamask"} />
      <div className="w-2" />
      Metamask
    </div>
  )
}

const MetamaskOnboarding = (startOnboarding) =>
  <a href="https://metamask.io/download/" target="_blank" rel="noreferrer">
    <HollowButtonContainer className="w-full" onClick={startOnboarding}>
      <MetamaskButton />
    </HollowButtonContainer>
  </a>

const WalletConnectButton = () =>
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
