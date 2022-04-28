import React from "react";
import { Footer } from "../components/Footer";
import { HollowInputContainer } from "../components/Hollow";
import Layout from "../components/Layouts";
import { useSubmissionFlowOpen } from "../components/SubmissionFlow";

function Home() {
  const [, setOpen] = useSubmissionFlowOpen();

  return (
    <div className="flex flex-col justify-center items-center relative w-full">
      <div className="sm:hidden text-center mx-4 flex flex-col justify-center items-center">
        <h1 className="text-6xl">Phlote</h1>
        <div className="h-16"></div>
        <p>
          Share music links to directly support independent artists by bridging
          them to Web3.
        </p>
      </div>

      <div className="hidden sm:block w-full">
        <div className="relative w-full flex justify-center">
          <h1 className="absolute w-full bottom-32 text-center text-2xl">
            Share music links to directly support independent artists by
            bridging them to Web3.{" "}
          </h1>
          {/* <SearchBar placeholder="Search our archive" /> */}
          <div className="w-80 h-16 cursor-pointer hover:opacity-75">
            <HollowInputContainer
              style={{ justifyContent: "center" }}
              onClick={() => setOpen(true)}
            >
              Submit music links here
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
      <div className="container flex justify-center mx-auto items-center flex-grow">
        {page}
      </div>
      <Footer />
    </Layout>
  );
};

export default Home;
