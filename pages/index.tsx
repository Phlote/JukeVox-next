import { useWeb3React } from "@web3-react/core";
import React from "react";
import { Footer } from "../components/Footer";
import { HollowInputContainer } from "../components/Hollow";
import Layout from "../components/Layouts";
import { useConnectWalletModalOpen } from "../components/Modals/ConnectWalletModal";
import { useSubmissionFlowOpen } from "../components/SubmissionFlow";
import { useSubmissionSearch } from "../hooks/useSubmissions";
import SubmissionCard from "../components/SubmissionCard";
import AliceCarousel from 'react-alice-carousel';
import 'react-alice-carousel/lib/alice-carousel.css';

const Hero = ({ account, setOpen, setConnectWalletOpen }) => {
  return (
    <section
      className="flex items-center justify-center py-44 bg-cover lg:py-80 bg-contain bg-center bg-no-repeat sm:bg-[url('/landing-page/map-landing-page.png')]">
      <div
        className="flex items-center">
        {/*Mobile*/}
        <div className="sm:hidden text-center mx-4 flex flex-col justify-center items-center">
          <h1 className="text-6xl">Phlote</h1>
          <div className="h-16"></div>
          <p>
            Decentralized music label run by a passionate community of music lovers.
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

const RecentlyCurated = () => {

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

    let recentSubs = [];
    submissions?.data?.pages.map((group, i) =>
        group?.submissions?.map((submission) => recentSubs.push(
          <SubmissionCard submission={submission} />)
        )
    )

  return (
    <section className="flex items-center justify-center sm:py-20 sm:mt-20 lg:mt-38">
      <div className="w-9/12 sm:w-8/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
        <h1 className="text-center italic text-5xl stroke-text">
          Recently Curated
        </h1>
        <h3 className="text-center italic opacity-70 font-light">
          These are some of the most wanted songs as voted on by the Phlote community.
        </h3>
        <div className="w-[320px] lg:w-[670px] xl:w-[1100px] 2xl:w-[1400px] flex justify-center">
          <AliceCarousel
            responsive={responsive}
            mouseTracking
            items={recentSubs}
            controlsStrategy="alternate"
            disableDotsControls
          />
        </div>
      </div>
    </section>
  );
}

const AboutUs = () => {
  return (
    <section className="flex items-center justify-center mt-14 sm:py-20 sm:mt-20 lg:mt-38">
      <div className="w-9/12 sm:w-8/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
        <h1 className="text-center italic text-5xl stroke-text">
          About Us
        </h1>
        <h3 className="text-center italic opacity-70 font-light">
          Phlote is a music label built to help musicians maximize the visibility and value of their work.{" "}
        </h3>
        <div className="relative mt-20 lg:mt-24">
          <div className="container flex flex-col-reverse lg:flex-row items-center justify-center gap-x-24">
            {/*Content*/}
            <div className="flex flex-1 flex-col sm:items-center lg:items-start">
              <h1 className="text-2xl sm:text-3xl font-extrabold">Merit Based Process</h1>
              {/*Todo: Think about making texts for mobile and desktop when its justified because
              of the - (dashes) between words used to better format */}
              <p className="my-4 text-justify sm:w-3/4 lg:w-full">
                Our process for selecting music is
                merit-based and relies on a passionate
                co-mmunity of music lovers who cosign
                the music we release in exchange for NFTs.
              </p>
            </div>
            {/*Image*/}
            <div className="flex flex-1 justify-center z-10 mb-10 lg:mb-0">
              <img
                className="w-5/6 h-5/6 sm:w-3/4 sm:h-3/4 md:w-full md:h-full"
                src="/landing-page/inverted-piramid.gif"
                alt=""
              />
            </div>
          </div>
        </div>
        <div className="relative mt-20 lg:mt-24">
          <div className="container flex flex-col lg:flex-row items-center justify-center gap-x-24">
            {/*Image*/}
            <div className="flex flex-1 justify-center z-10 mb-10 lg:mb-0">
              <img
                className="w-5/6 h-5/6 sm:w-3/4 sm:h-3/4 md:w-full md:h-full"
                src="/connections.png"
                alt=""
              />
            </div>
            {/*Content*/}
            <div className="flex flex-1 flex-col sm:items-center lg:items-start">
              <h1 className="text-2xl sm:text-3xl font-extrabold">Free Ethereum Minting</h1>
              <p className="my-4 text-justify sm:w-3/4 lg:w-full">
                Phlote’s curation protocol is connected to
                Zora’s marketplace protocol, creating a pathway for any artist to
                mint music on the Ethereum blockchain
                without the restriction of gas fees. Curation on Phlote
                automatically launches NFT auctions on
                Zora, protocol-to-protocol.
              </p>
            </div>
          </div>
        </div>
        <div className="relative mt-20 lg:mt-24">
          <div className="container flex flex-col-reverse lg:flex-row items-center justify-center gap-x-24">
            {/*Content*/}
            <div className="flex flex-1 flex-col lg:items-start">
              <h1 className="text-2xl sm:text-3xl font-extrabold">Programmatic Rewards</h1>
              <p className="my-4 text-justify lg:text-left sm:w-3/4 lg:w-full">
                All minting fees are paid by Phlote in
                exchange for 10% of the NFT sale price.
                Phlote operates a custom contract that
                directs funds automatically to curators
                and artists. Phlote DAO’s share of the
                sales proceeds is recirculated to the DAO treasury and used to fund fees for
                future artists.
              </p>
            </div>
            {/*Image*/}
            <div className="flex flex-1 justify-center z-10 mb-10 lg:mb-0">
              <img
                className="w-5/6 h-5/6 sm:w-3/4 sm:h-3/4 md:w-full md:h-full"
                src="/landing-page/ethereum.png"
                alt=""
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

const HowItWorks = () => {
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

const Collaborators = () => {
  return (
    <section className="flex items-center justify-center py-20 mt-20 lg:mt-38">
      <div
        className="flex flex-col gap-8 items-center w-10/12">
        <div className="flex flex-col justify-center items-center pt-10 gap-4">
          <h1 className="text-center text-4xl sm:text-6xl stroke-text">
            Our Collaborators
          </h1>
          <h3 className="text-center text- sm:text-lg opacity-70 font-light">
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
    <div className="font-roboto">
      <Hero account={account} setOpen={setOpen} setConnectWalletOpen={setConnectWalletOpen} />
      <RecentlyCurated />
      <AboutUs />
      <HowItWorks />
      <SubmissionSchedule />
      <Collaborators />
    </div>
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
