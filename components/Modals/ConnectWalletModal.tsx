import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import React from "react";
import { Injected, WalletConnect } from "../../utils/connectors";
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
    <Modal open={open}>
      <div className="w-full p-8 flex flex-col justify-center items-center text-center">
        <button
          onClick={() => {
            activate(WalletConnect);
          }}
        >
          Wallet Connect
        </button>
        <button
          onClick={() => {
            activate(Injected);
          }}
        >
          Metamask
        </button>
      </div>
    </Modal>
  );
};
