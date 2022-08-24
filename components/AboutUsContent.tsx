import React from "react";

const AboutUsContent = () => {
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

export default AboutUsContent;
