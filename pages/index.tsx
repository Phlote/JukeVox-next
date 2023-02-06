import React, { useEffect, useState } from "react";
import { Footer } from "../components/Footer";
import { HollowInputContainer } from "../components/Hollow";
import Layout from "../components/Layouts";
import { useConnectWalletModalOpen } from "../components/Modals/ConnectWalletModal";
import { useSubmissionFlowOpen } from "../components/SubmissionFlow";
import 'react-alice-carousel/lib/alice-carousel.css';
import TempHowItWorks from "../components/TempHowItWorks";
import { useMoralis } from "react-moralis";
import { supabase } from "../lib/supabase";
import RecentlyCurated from "../components/RecentlyCurated";
import Image from "next/image";

const Hero = ({ account, setOpen, setConnectWalletOpen }) => {
  return (
    <section
      className="flex items-center justify-center py-24 bg-cover lg:py-80 bg-contain bg-center bg-no-repeat sm:bg-[url('/landing-page/map-landing-page.png')]">
      <div
        className="flex items-center">
        {/*Mobile*/}
        <div className="sm:hidden text-center mx-4 flex flex-col justify-center items-center">
          <div className='w-48 h-24 relative'>
            <Image src='/newLogo.png' className="cursor-pointer object-contain" alt='' layout='fill'/>
          </div>
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

function Home({ submissions }) {
  const [, setOpen] = useSubmissionFlowOpen();

  const { account } = useMoralis();
  const [, setConnectWalletOpen] = useConnectWalletModalOpen();

  return (
    <>
      <div className="hidden sm:block font-roboto"> {/* Desktop */}
        <RecentlyCurated {...{ account, setOpen, setConnectWalletOpen, submissions }}/>
        {/*<Collaborators />*/}
      </div>
      <div className="sm:hidden font-roboto"> {/* Mobile */}
        <Hero account={account} setOpen={setOpen} setConnectWalletOpen={setConnectWalletOpen} />
        <RecentlyCurated {...{ account, setOpen, setConnectWalletOpen, submissions }}/>
        <TempHowItWorks />
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

export async function getStaticProps<GetStaticProps>() {
  const submissions = await supabase
    .from("submissions")
    .select()
    .match({ noOfCosigns: 5 });

  return {
    props: {
      submissions: submissions
    }
  };
}
