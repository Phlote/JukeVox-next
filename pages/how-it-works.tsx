import React from "react";
import { Footer } from "../components/Footer";
import Layout from "../components/Layouts";
import HowItWorksContent from "../components/HowItWorksContent";
import SubmissionScheduleContent from "../components/SubmissionScheduleContent";

function HowItWorks() { // LANDING PAGE
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
