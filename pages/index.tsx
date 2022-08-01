import { useWeb3React } from "@web3-react/core";
import React from "react";
import { Footer } from "../components/Footer";
import { HollowInputContainer } from "../components/Hollow";
import Layout from "../components/Layouts";
import { useConnectWalletModalOpen } from "../components/Modals/ConnectWalletModal";
import { useSubmissionFlowOpen } from "../components/SubmissionFlow";

function titleSection(){

}

function Home() {
  const [, setOpen] = useSubmissionFlowOpen();

  const { account } = useWeb3React();
  const [, setConnectWalletOpen] = useConnectWalletModalOpen();

  return (
    <div className="flex flex-col justify-center items-center relative w-full">
      {/*Mobile*/}
      <div className="sm:hidden text-center mx-4 flex flex-col justify-center items-center">
        <h1 className="text-6xl">Phlote</h1>
        <div className="h-16"></div>
        <p>
          Decentralized music label run by a passionate community of music lovers.
        </p>
      </div>

      {/*Desktop*/}
      <div className="hidden sm:block w-full bg-center bg-no-repeat bg-[url('/landing-map.png')]">
        <div className=" w-full flex flex-col justify-center items-center">
          <h1 className="text-center italic text-2xl">
            Decentralized music label run by a passionate community of music lovers.{" "}
          </h1>
          <h3 className="text-center italic text-xl opacity-70">
            Artist submissions the recieve 5 co-signs are minted every Tuesday on Zora.{" "}
          </h3>
          <div className="h-16" />
          <div className="w-80 h-16 cursor-pointer hover:opacity-75 shadow-sm">
            <HollowInputContainer
              style={{ justifyContent: "center", border: "1px solid white" }}
              onClick={() => {
                if (account) setOpen(true);
                else setConnectWalletOpen(true);
              }}
            >
              {account ? "Submit music to Phlote" : "Connect"}
            </HollowInputContainer>
          </div>
        </div>
      </div>
    </div>
  );
}

Home.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center h-screen">
        {page}
      </div>
      <Footer />
    </Layout>
  );
};

export default Home;
