import { useWeb3React } from "@web3-react/core";
import React, { useEffect, useLayoutEffect } from "react";
import { Footer } from "../components/Footer";
import { HollowInputContainer } from "../components/Hollow";
import Layout from "../components/Layouts";
import { useConnectWalletModalOpen } from "../components/Modals/ConnectWalletModal";
import { useSubmissionFlowOpen } from "../components/SubmissionFlow";
import { useSearchFilters, useSubmissionSearch } from "../hooks/useSubmissions";
import SubmissionCard from "../components/SubmissionCard";
import AliceCarousel from 'react-alice-carousel';
import 'react-alice-carousel/lib/alice-carousel.css';
import { Submission } from "../types";
import AboutUsContent from "../components/AboutUsContent";
import HowItWorksContent from "../components/HowItWorksContent";
import SubmissionScheduleContent from "../components/SubmissionScheduleContent";
import TempHowItWorks from "../components/TempHowItWorks";

const Hero = ({ account, setOpen, setConnectWalletOpen }) => {
  return (
    <section
      className="flex items-center justify-center py-24 bg-cover lg:py-80 bg-contain bg-center bg-no-repeat sm:bg-[url('/landing-page/map-landing-page.png')]">
      <div
        className="flex items-center">
        {/*Mobile*/}
        <div className="sm:hidden text-center mx-4 flex flex-col justify-center items-center">
          <h1 className="text-6xl">Phlote</h1>
          <div className="h-16"></div>
          <p>
            Phlote delivers the best new genre-bending music from around the world to our members as exclusive music NFTs.
          </p>
          <div className="h-16"></div>
          <div className="w-80 mt-80 h-16 cursor-pointer hover:opacity-75 shadow-sm">
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

        {/*Desktop*/}
        <div className="hidden sm:block w-full]">
          <div className=" w-full flex flex-col gap-2 justify-center items-center pt-10">
            <h1 className="text-center italic text-4xl sm:text-2xl">
              Decentralized music label run by a passionate community of music lovers.{" "}
            </h1>
            <h3 className="text-center italic text-2xl sm:text-xl opacity-70">
              Artist submissions the receive 5 co-signs are minted every Tuesday on Zora.{" "}
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
    </section>
  );
}

const RecentlyCurated = ({ account, setOpen, setConnectWalletOpen }) => {
  const [selectedFilters, setFilters] = useSearchFilters();

  useEffect(() => {
    setFilters({ noOfCosigns: 5 });

    return ()=>{ // Clean up filters so it doesn't pass along to /Feed
      setFilters({});
    }
  }, []);

  const submissions = useSubmissionSearch();
  const noResults =
    !submissions.isLoading &&
    !submissions.isFetching &&
    submissions.data?.pages[0].submissions.length === 0;

  const responsive = {
    640: { items: 1 },
    1024: { items: 2 },
    1280: { items: 3 },
    1700: { items: 4 },
  };

  let cosignedSubs = [];
  if (!(submissions.isLoading || submissions.isFetching) && !noResults) {
    submissions?.data?.pages.map((group, i) =>
      group?.submissions?.map((submission: Submission) => {
          cosignedSubs.push(<SubmissionCard submission={submission} />)
        }
      )
    )
  }
  // console.log(cosignedSubs);

  return (
    <section className="flex items-center justify-center sm:py-20 sm:mt-5">
      {/* Desktop */}
      <div className="hidden sm:flex w-full flex-col justify-center items-center pt-10 gap-4">
        <h1 className="hidden text-center italic lg:text-xl 2xl:text-4xl">
          Decentralized music label run by a passionate community of music lovers.{" "}
        </h1>
        <h3 className="hidden text-center italic lg:text-lg 2xl:text-2xl opacity-70">
          Artist submissions the receive 5 co-signs are minted every Tuesday on Zora.{" "}
        </h3>
        <div className="w-[320px] lg:w-[670px] xl:w-[1100px] 2xl:w-[1400px] flex justify-center">
          <AliceCarousel
            responsive={responsive}
            mouseTracking
            items={cosignedSubs}
            controlsStrategy="alternate"
            disableDotsControls
            disableButtonsControls
          />
        </div>
        <div className="h-2"></div>
        <h3 className="text-center italic opacity-70 font-light lg:text-lg 2xl:text-2xl">
          Community Curated by Team Phlote
        </h3>
        <div className="h-2"></div>
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
      {/* Mobile */}
      <div className="sm:hidden w-9/12 sm:w-8/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
        {/*<h1 className="text-center italic text-5xl stroke-text">*/}
        {/*  Recently Curated*/}
        {/*</h1>*/}
        <div className="w-[320px] lg:w-[670px] xl:w-[1100px] 2xl:w-[1400px] flex justify-center">
          <AliceCarousel
            responsive={responsive}
            mouseTracking
            items={cosignedSubs}
            controlsStrategy="alternate"
            disableDotsControls
          />
        </div>
        <h3 className="text-center italic opacity-70 font-light">
          These are some of the most wanted songs as voted on by the Phlote community.
        </h3>
      </div>
    </section>
  );
}

const Collaborators = () => {
  return (
    <section className="flex items-center justify-center py-20 mt-20 lg:mt-38">
      <div
        className="flex flex-col gap-8 items-center w-10/12">
        <div className="flex flex-col justify-center items-center pt-10 gap-4">
          <h1 className="text-center text-4xl sm:text-6xl stroke-text">
            Press + Partners
          </h1>
          <h3 className="sm:hidden text-center text- sm:text-lg opacity-70 font-light">
            Web 3.0 is all about supporting and building together for a better world.
          </h3>
        </div>
        <div className="w-80 flex gap-5 flex-wrap justify-center sm:flex-nowrap">
          <img className="h-16 md:h-24" src="/landing-page/collaborators/colab1.png" />
          <img className="h-16 md:h-24" src="/landing-page/collaborators/colab2.png" />
          <img className="h-16 md:h-24" src="/landing-page/collaborators/colab3.png" />
          <img className="h-16 md:h-24" src="/landing-page/collaborators/colab4.png" />
        </div>
      </div>
    </section>
  );
}

function Home() { // LANDING PAGE
  const [, setOpen] = useSubmissionFlowOpen();

  const { account } = useWeb3React();
  const [, setConnectWalletOpen] = useConnectWalletModalOpen();

  return (
    <>
      <div className="hidden sm:block font-roboto"> {/* Desktop */}
        <RecentlyCurated account={account} setOpen={setOpen} setConnectWalletOpen={setConnectWalletOpen} />
        {/*<Collaborators />*/}
      </div>
      <div className="sm:hidden font-roboto"> {/* Mobile */}
        <Hero account={account} setOpen={setOpen} setConnectWalletOpen={setConnectWalletOpen} />
        <RecentlyCurated account={account} setOpen={setOpen} setConnectWalletOpen={setConnectWalletOpen} />
        <TempHowItWorks/>
        {/*<AboutUsContent />*/}
        {/*<HowItWorksContent />*/}
        {/*<SubmissionScheduleContent />*/}
        {/*<Collaborators />*/}
      </div>
    </>
  );
}

Home.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center">
        {page}
      </div>
      <Footer />
    </Layout>
  );
};

export default Home;
