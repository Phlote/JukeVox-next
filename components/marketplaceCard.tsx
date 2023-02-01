import { useCallback, useEffect, useState } from "react";
import Web3 from "web3";
import { Web3_Socket_URL } from "../utils/constants";
import { HotdropABI } from "../solidity/utils/Hotdrop";
import { AbiItem } from "web3-utils";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import MintButton from "./MintButton";

const web3 = new Web3(Web3_Socket_URL);

/* TODO:
        - Fix buttons alignment
        - Download Files
        - Expired Sales
*/
export const MarketPlaceCard = ({ submission }) => {
  const [saleItem, setSaleItem] = useState({ maxSupply: 20, price: 0.01, ...submission});
  const [copiesSold, setCopiesSold] = useState(0);
  const { account } = useMoralis();

  useEffect(() => {
    if (saleItem?.hotdropAddress.length > 0) getCopies();
  }, [saleItem]);

  async function getCopies() {
    //Error: This contract object doesn't have address set yet, please set an address first. Is in here. If you replace
    // saleItem.hotdropaddress with hardcoded address it works.
    console.log(saleItem);
    const hotdropContract = new web3.eth.Contract(HotdropABI as unknown as AbiItem, saleItem.hotdropAddress);
    const numOfMints = await hotdropContract.methods.totalSupply(3).call();
    setCopiesSold(numOfMints);
  }

  const isAllowedToDownload = async () => {
    const hotdropContract = new web3.eth.Contract(HotdropABI as unknown as AbiItem, saleItem.hotdropAddress);
    const regularNFTResult = await hotdropContract.methods.balanceOf(account, 3).call();
    const curatorNFTResult = await hotdropContract.methods.balanceOf(account, 1).call();
    const artistNFTResult = await hotdropContract.methods.balanceOf(account, 0).call();
    const total = Number(regularNFTResult) + Number(curatorNFTResult) + Number(artistNFTResult);

    if (total > 0) {
      return true;
    } else {
      return false;
    }
  };

  const handleDownload = useCallback(async () => {
    const result = await isAllowedToDownload();
    if (result == true) {
      const downloadLink = document.createElement("a");
      downloadLink.href = saleItem.mediaURI;
      downloadLink.download = `${saleItem.artistName} - ${saleItem.mediaTitle}.mp3`;
      downloadLink.click();
      console.log("you may download it");
    } else {
      console.log("sorry you cant download this");
    }
  }, []);

  return (
    <div className="bg-white rounded-lg shadow-lg" key={saleItem.submissionID}>
      <img src={"/default_submission_image.jpeg"} alt="item" className="w-full h-80 object-cover" />
      <div className="pt-4 pr-2 pl-2 h-28">
        <div className="text-center">
          <h2 className="text-lg text-black font-medium">
            {saleItem.artistName} - {saleItem.mediaTitle}
          </h2>
        </div>
        <div className="text-center mt-4">
          <p className="text-gray-600">Copies Sold:{copiesSold}</p>
          <p className="text-gray-600">Price: {saleItem.price} Matic </p>
        </div>
      </div>
      <div className="text-center mt-4 p-4 d-flex align-items-center">
        <MintButton color="bg-indigo-500" text="Loading..." hotdropAddress={saleItem.hotdropAddress}
                       hoverColor="bg-indigo-300" />
        <button className="bg-gray-200 text-gray-800 py-2 px-4 rounded-lg ml-2 hover:bg-gray-300"
                onClick={handleDownload}>
          Download Files
        </button>
        {/* <button
          className={`bg-gray-200 text-gray-800 py-2 px-4 rounded-lg ml-2 hover:bg-gray-300 ${!allowedToDownload ? "opacity-50 cursor-not-allowed" : ""}`}
          onClick={handleDownload}
          disabled={!allowedToDownload}
        >
          {allowedToDownload ? "Download Files" : "You cant download"}
        </button> */}
        {/* <a href="https://ipfs.io/ipfs/QmPGCQbetutKBNix9ZaQ1xoF4HaNaaNBvKK67h5b8uv91o" download="file">Download Files</a> */}
      </div>
    </div>
  );
};
