import { atom, useAtom } from "jotai";
import { Modal } from "../Modal";

const connectWalletModalOpenAtom = atom<boolean>(false);
const useConnectWalletModalOpen = () => useAtom(connectWalletModalOpenAtom);

export const ConnectWalletModal = () => {
  const [open, setOpen] = useConnectWalletModalOpen();
  return <Modal open={open}></Modal>;
};
