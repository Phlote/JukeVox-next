import React, { useEffect, useState } from "react";
import Layout from "../components/Layouts";
import { useSubmissions } from "../hooks/useSubmissions";
import Web3 from "web3";
import { Web3_Socket_URL } from "../utils/constants";
import { HotdropABI } from "../solidity/utils/Hotdrop";
import { AbiItem } from "web3-utils";
import { MarketPlaceCard } from "../components/marketplaceCard";

const Marketplace = () => {
  const allCosignedSubmissions = useSubmissions({ noOfCosigns: 5, isArtist: true });
  const expiredItems = []

  /*
  TODO:
  - Build expiredItems list
  - Filter the display with the highest sales at the top of the list
  */

  return (
    <div className="font-roboto">
      <section className="flex items-center justify-center mt-14 sm:py-20 sm:mt-20 lg:mt-38">
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col pt-10 gap-4">
          <div className="container mx-auto p-4">
            <h2 className="text-6xl text-green-100 font-bold uppercase">Live Releases:</h2>
            {allCosignedSubmissions.length == 0 ? (
              <div className="justify-center">
                <h1 className="text-2xl justify-center font-bold uppercase mt-20">There are currently no live
                  releases...</h1>
              </div>
            ) : (
              <div className="grid grid-cols-1 mt-10 md:grid-cols-2 lg:grid-cols-4 gap-4">
                {allCosignedSubmissions.filter(s=>s.hotdropAddress.length > 0).map((saleItem, index) =>
                  <MarketPlaceCard submission={saleItem} key={index} />
                )}
              </div>
            )}
            <h2 className="text-6xl text-red-600 font-bold uppercase mt-20">Expired Releases:</h2>

            {expiredItems.length == 0 ? (
              <div className="justify-center">
                <h1 className="text-2xl justify-center font-bold uppercase mt-20">There are currently no expired
                  releases...</h1>
              </div>
            ) : (
              <div className="grid grid-cols-1 mt-10 md:grid-cols-2 lg:grid-cols-5 gap-4">
                {expiredItems.map((expiredItems) => (
                  <div className="bg-white rounded-lg shadow-lg" key={expiredItems.submissionID}>
                    <img src={"/default_submission_image.jpeg"} alt="item" className="w-full h-80 object-cover" />
                    <div className="p-6">
                      <div className="text-center">
                        <h2 className="text-lg text-black font-medium">
                          {expiredItems.artistName} - {expiredItems.mediaTitle}
                        </h2>
                      </div>
                      <div className="text-center mt-4">
                        <p className="text-gray-600">Copies Sold: 0 {expiredItems.copiesSold}</p>
                        <p className="text-gray-600">Price: 0.01 Matic </p>
                      </div>
                      <div className="text-center mt-4">
                        <button className="bg-indigo-500 text-white py-2 px-4 rounded-lg hover:bg-indigo-600">Mint
                        </button>
                        <button
                          className="bg-gray-200 text-gray-800 py-2 px-4 rounded-lg ml-2 hover:bg-gray-300">Download
                          Files
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

        </div>
      </section>
    </div>
  );
};

Marketplace.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center">{page}</div>
    </Layout>
  );
};

export default Marketplace;
