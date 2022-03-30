import { useWeb3React } from "@web3-react/core";
import { useEffect, useState } from "react";
import { RINKEBY_CHAIN_ID } from "../../constants";
import { HollowButton, HollowButtonContainer } from "../Hollow";
import { Modal } from "../Modal";

export const RinkebyPromptModal = () => {
  const [open, setOpen] = useState<boolean>(false);
  const { active, chainId, library } = useWeb3React();
  useEffect(() => {
    if (active) {
      if (chainId !== RINKEBY_CHAIN_ID) {
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
