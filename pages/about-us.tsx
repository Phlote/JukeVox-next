import React from "react";
import { Footer } from "../components/Footer";
import Layout from "../components/Layouts";
import AboutUsContent from "../components/AboutUsContent";

function AboutUs() { // LANDING PAGE
  return (
    <div className="font-roboto">
      <AboutUsContent />
    </div>
  );
}

AboutUs.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center">
        {page}
      </div>
      <Footer />
    </Layout>
  );
};

export default AboutUs;
