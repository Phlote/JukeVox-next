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
  width: 60rem;
  height: 35rem;

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
        <h1>Welcome to the Phlote Search Beta!</h1>
        <div className="h-8" />
        <p>
          {`We're testing on Rinkeby Testnet for the time being to keep
          transactions completely free as we test.`}
        </p>
        <br></br>
        <p>
          {`You will need test ETH, which is retrievable from the link below. Submit your wallet address to get 0.1 test ETH for free! `}
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
        <p>Automatically switch to the test network using the button below.</p>
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
          {`Once done, you're set to submit! Pls ping the team on the #feedback channel on `}
          <a
            rel="noreferrer"
            target="_blank"
            href="https://discord.com/invite/Pdq24r4P5J"
            className="underline"
          >
            Discord
          </a>
          {` with any ideas on how we can improve the submission/search process.`}
        </p>

        <div className="h-8" />
      </div>
    </Modal>
  );
};
