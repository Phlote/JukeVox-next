import { useEffect, useState } from "react"
import Web3 from "web3";
import { Web3_Socket_URL } from "../utils/constants";
import { HotdropABI } from "../solidity/utils/Hotdrop";
import { AbiItem } from "web3-utils";
import Account from "./Account";

const web3 = new Web3(Web3_Socket_URL);

export const MarketPlaceCard = ({account, submission:{ submissionID, artistName, mediaTitle, hotdropAddress, mediaURI } }) => {

    const [saleItem, setSaleItem] = useState({ submissionID, artistName, mediaTitle, hotdropAddress, maxSupply: 20, price: 0.01, mediaURI });
    const [copiesSold, setCopiesSold] = useState(0)
    const [allowedToDownload,setAllowedToDownload] = useState(false)

    useEffect(()=>{
        getCopies()
    },[])
  //  console.log(saleItem.hotdropAddress)
    async function getCopies () {
        //Error: This contract object doesn't have address set yet, please set an address first. Is in here. If you replace
        // saleItem.hotdropaddress with hardcoded address it works.
        const hotdropContract = new web3.eth.Contract(HotdropABI as unknown as AbiItem, saleItem.hotdropAddress);
        const numOfMints = await hotdropContract.methods.totalSupply(3).call()
        setCopiesSold(numOfMints)
      }


    const isAllowedToDownload = async() => {
      const hotdropContract = new web3.eth.Contract(HotdropABI as unknown as AbiItem, saleItem.hotdropAddress);
      const regularNFTResult = await hotdropContract.methods.balanceOf(account, 3).call()
      const curatorNFTResult = await hotdropContract.methods.balanceOf(account, 1).call()
      const artistNFTResult = await hotdropContract.methods.balanceOf(account, 0).call()
      const total = Number(regularNFTResult) + Number(curatorNFTResult) + Number(artistNFTResult)

      if(total > 0){
        console.log("you own: ", total)
        setAllowedToDownload(true)
      }
      else{
        console.log("you own none of this ")
        setAllowedToDownload(false)
      }
    };


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
        <div className="text-center mt-4 p-4">
          <button className="bg-indigo-500 text-white py-2 px-4 rounded-lg hover:bg-indigo-600">Mint</button>
          <button className="bg-gray-200 text-gray-800 py-2 px-4 rounded-lg ml-2 hover:bg-gray-300" onClick={isAllowedToDownload}>
            Download Files 
            </button>
                        {/* <a href="https://ipfs.io/ipfs/QmPGCQbetutKBNix9ZaQ1xoF4HaNaaNBvKK67h5b8uv91o" download="file">Download Files</a> */}

        </div>
      </div>
    );
}