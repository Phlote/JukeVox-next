import React, { useState, useEffect } from "react";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import { HotdropABI } from "../solidity/utils/Hotdrop";
import { AbiItem } from "web3-utils";
import { Web3_Socket_URL } from "../utils/constants";
import Web3 from "web3";




interface Props {
    hotdropAddress: string;

  text: string;
  onClick?: () => void;
}

const DownloadButton: React.FC<Props> = ({ hotdropAddress, text, onClick }) => {
    const { isWeb3Enabled, account } = useMoralis();

    useEffect(()=>{
        getCopies(hotdropAddress)
    },[])

    async function getCopies (hotdropAddress) {
        console.log("address from getCopies:",hotdropAddress)
        const web3 = new Web3(Web3_Socket_URL);
        const hotdropContract = new web3.eth.Contract(HotdropABI as unknown as AbiItem, hotdropAddress);
        const numOfMints = await hotdropContract.methods.totalSupply(3).call()
        setCopiesSold(numOfMints)
      }

    
    const handelDownload = (e) => {
        e.preventDefault()
        window.open ('https://www.google.com/', '_ blank');
      } 

  return (
    <button
      className={`w-full bg-indigo-500 text-white py-2 px-4 rounded-lg hover:bg-indigo-600
         cursor-pointer`}
      onClick={handelDownload}
    >
      {text}
    </button>
  );
};

export default DownloadButton;
