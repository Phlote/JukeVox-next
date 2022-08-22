import React from "react";

const HowItWorksContent = () => {
  return (
    <section className="flex items-center justify-center py-20 mt-20">
      <div className="w-9/12 flex flex-col justify-center items-center">
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
              <p className="mb-2 text-justify font-light">Curators share music of their favorite artists. Tap into a
                community that really cares about music. </p>
            </div>
          </div>
          <div className="flex flex-col rounded-md shadow-md">
            <div className="p-6 flex flex-col items-center">
              <img src="./imgs/logo-opera.svg" alt="" />
              <h1 className="mt-5 mb-2 text-3xl font-extrabold">Auction</h1>
              <p className="mb-2 text-justify font-light">Proceeds from NFT sales are split 85/5/10 between Artist,
                Zora, and Phlote DAO</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default HowItWorksContent;
