import { useWeb3React } from "@web3-react/core";
import React, { useEffect } from "react";
import { Footer } from "../components/Footer";
import Layout from "../components/Layouts";
import { useConnectWalletModalOpen } from "../components/Modals/ConnectWalletModal";
import { useSubmissionFlowOpen } from "../components/SubmissionFlow";
import HowItWorksContent from "../components/HowItWorksContent";
import SubmissionScheduleContent from "../components/SubmissionScheduleContent";

function HowItWorks() { // LANDING PAGE
  const [, setOpen] = useSubmissionFlowOpen();

  const { account } = useWeb3React();
  const [, setConnectWalletOpen] = useConnectWalletModalOpen();

  return (
    <div className="font-roboto">
      <HowItWorksContent />
      <SubmissionScheduleContent />
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
