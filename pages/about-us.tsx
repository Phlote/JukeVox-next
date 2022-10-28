import React from "react";
import { Footer } from "../components/Footer";
import Layout from "../components/Layouts";
import AboutUsContent from "../components/AboutUsContent";

let TempAboutUs = ()=>
  <section className="flex items-center justify-center mt-14 sm:py-20 sm:mt-20 lg:mt-38">
    <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
      <h1 className="text-2xl sm:text-7xl font-extrabold">Phlote delivers the best new genre-bending music from around the world to our members as exclusive music NFTs.</h1>
    </div>
  </section>

function AboutUs() { // LANDING PAGE
  return (
    <div className="font-roboto">
      {/*<AboutUsContent />*/}
      <TempAboutUs/>
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
