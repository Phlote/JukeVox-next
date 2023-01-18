import { useEffect, useState } from "react"
import Web3 from "web3";
import { Web3_Socket_URL } from "../utils/constants";
import { HotdropABI } from "../solidity/utils/Hotdrop";
import { AbiItem } from "web3-utils";

export const MarketPlaceCard = ({submission:{ submissionID, artistName, mediaTitle, hotdropAddress } }) => {

    const [saleItem, setSaleItem] = useState({ submissionID, artistName, mediaTitle, hotdropAddress, maxSupply: 20, price: 0.01 });
    const [copiesSold, setCopiesSold] = useState(0)
    useEffect(()=>{
        getCopies(saleItem.hotdropAddress)
    },[])
    async function getCopies (hotdropAddress) {
        console.log("address from getCopies:",hotdropAddress)
        const web3 = new Web3(Web3_Socket_URL);
        const hotdropContract = new web3.eth.Contract(HotdropABI as unknown as AbiItem, hotdropAddress);
        const numOfMints = await hotdropContract.methods.totalSupply(3).call()
        setCopiesSold(numOfMints)
      }

    return(
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
                      {/* HERE we can have the mint modal pop up */}
                      <button className="bg-indigo-500 text-white py-2 px-4 rounded-lg hover:bg-indigo-600">Mint</button>
                      <button className="bg-gray-200 text-gray-800 py-2 px-4 rounded-lg ml-2 hover:bg-gray-300">Download Files</button>
                    </div>
                </div>
    )
}