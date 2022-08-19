import { useWeb3React } from "@web3-react/core";
import React, { useEffect } from "react";
import { Footer } from "../components/Footer";
import Layout from "../components/Layouts";
import { useConnectWalletModalOpen } from "../components/Modals/ConnectWalletModal";
import { useSubmissionFlowOpen } from "../components/SubmissionFlow";

const Content = () => {
  return (
    <section className="flex items-center justify-center py-20 mt-20">
      <div className="w-9/12">
        <div className="sm:w-3/4 lg:w-5/12 mx-auto px-2">
          <h1 className="text-center italic text-5xl stroke-text">How it works</h1>
        </div>
        <div className="container grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-16 max-w-screen-lg mt-8">
          <div className="flex flex-col rounded-md shadow-md">
            <div className="p-6 flex flex-col items-center">
              <img src="./imgs/logo-chrome.svg" alt="" />
              <h1 className="mt-5 mb-2 text-3xl font-extrabold">Artist</h1>
              <p className="mb-2 text-justify font-light">Artists post music that’s reviewed by token holders who cosign
                their favorite tracks. Artist submissions that receives 5 cosigns are pro-grammatically minted on Zora,
                with mint fees paid by Phlote.</p>
            </div>
          </div>
          <div className="flex flex-col rounded-md shadow-md">
            <div className="p-6 flex flex-col items-center">
              <img src="./imgs/logo-firefox.svg" alt="" />
              <h1 className="mt-5 mb-2 text-3xl font-extrabold">Curator</h1>
              <p className="mb-2 text-justify font-light">Curators earn Phlote tokens ($PV1) for sharing the music of
                their favorite artists that can be re-deemed for music NFTs.</p>
            </div>
          </div>
          <div className="flex flex-col rounded-md shadow-md">
            <div className="p-6 flex flex-col items-center">
              <img src="./imgs/logo-opera.svg" alt="" />
              <h1 className="mt-5 mb-2 text-3xl font-extrabold">Auction</h1>
              <p className="mb-2 text-justify font-light">Proceeds from NFT sales on Zora are split 85/5/10 between
                artist, Zora, and Phlote DAO.</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

const SubmissionSchedule = () => {
  return (
    <section className="flex items-center justify-center lg:mt-38">
      <div className=" w-full flex flex-col justify-center items-center pt-10 gap-4">
        <h1 className="text-center italic text-3xl sm:text-5xl font-extrabold">
          Submissions Schedule
        </h1>
        <h3 className="text-center italic opacity-70 font-light">
          All tracks that receive 5 cosigns are scheduled to be auctioned on Zora.
        </h3>
        <div className="relative hidden sm:block">
          <img className="w-full" src="/landing-page/submissions-dates-b&w.png" />
        </div>
      </div>
    </section>
  );
}

function HowItWorks() { // LANDING PAGE
  const [, setOpen] = useSubmissionFlowOpen();

  const { account } = useWeb3React();
  const [, setConnectWalletOpen] = useConnectWalletModalOpen();

  return (
    <div className="font-roboto">
      <Content />
      <SubmissionSchedule />
    </div>
  );
}

HowItWorks.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center">
        {page}
      </div>
      <Footer />
    </Layout>
  );
};

export default HowItWorks;
