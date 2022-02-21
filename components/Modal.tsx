import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import { useEffect, useState } from "react";
import styled from "styled-components";
import { NETWORKS, RINKEBY_CHAIN_ID } from "../constants";
import { HollowButtonContainer, HollowButton } from "./Hollow";

interface ModalProps {
  open: boolean;
  onClose?: () => void;
}

export const Modal: React.FC<ModalProps> = ({ children, open, onClose }) => {
  return (
    <div
      className="flex w-screen h-screen absolute z-20 justify-center items-center"
      style={!open ? { display: "none" } : undefined}
    >
      {open && (
        <div
          className="opacity-0 flex-grow min-h-full min-w-full -z-10"
          onClick={onClose}
        ></div>
      )}

      <ModalContainer>{children}</ModalContainer>
    </div>
  );
};

const ModalContainer = styled.div`
  position: absolute;
  width: 50vw;
  height: 80vh;

  color: white;
  padding: 1rem;
  background: linear-gradient(
      85.96deg,
      rgba(255, 255, 255, 0) -20.51%,
      rgba(255, 255, 255, 0.05) 26.82%,
      rgba(255, 255, 255, 0) 65.65%
    ),
    rgba(255, 255, 255, 0.05);
  box-shadow: inset 0px -2.50245px 1.25122px rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(37.5367px);
  /* Note: backdrop-filter has minimal browser support */

  border-radius: 100px;
`;

export const RinkebyPromptModal = () => {
  const [open, setOpen] = useState<boolean>(false);
  const { active, chainId, library } = useWeb3React();
  useEffect(() => {
    if (active) {
      console.log("active");
      if (chainId !== RINKEBY_CHAIN_ID) {
        console.log("not on rinkeby");
        setOpen(true);
      } else setOpen(false);
    }
  }, [active, chainId]);

  return (
    <Modal open={open}>
      <div className="w-full p-8 flex flex-col justify-center items-center text-center">
        <h1>Welcome to the Phlote Beta!</h1>
        <div className="h-8" />
        <p>
          {" "}
          We use the Rinkeby Testnet for the time being. This means that
          transactions are completely free.
        </p>
        <br></br>
        <p>
          You will need test ETH, go to the link below and submit your wallet
          address. You will get 0.1 test ETH for free! (You don't need any LINK)
        </p>
        <div className="h-8" />

        <a
          rel="noreferrer"
          target="_blank"
          href={"https://faucets.chain.link/rinkeby"}
          className="underline"
        >
          https://faucets.chain.link/rinkeby
        </a>
        <div className="h-8" />
        <p>Afterwards, click the button below to switch networks.</p>
        <div className="h-8" />

        <HollowButtonContainer
          className="w-1/2 cursor-pointer"
          onClick={() => {
            library?.send("wallet_switchEthereumChain", [
              { chainId: `0x${Number(RINKEBY_CHAIN_ID).toString(16)}` },
            ]);
          }}
        >
          <HollowButton>Switch To Rinkeby</HollowButton>
        </HollowButtonContainer>
        <div className="h-8" />
        <p>
          Once all of that is done, you should be good to go! Ping the team on{" "}
          <a
            rel="noreferrer"
            target="_blank"
            href="https://discord.gg/AMcqNcTm"
            className="underline"
          >
            Discord
          </a>{" "}
          with any feedback you may have.
        </p>
        <div className="h-8" />
      </div>
    </Modal>
  );
};
