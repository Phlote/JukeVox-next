import React, {useEffect, useState } from "react";
import { HotdropABI } from "../../solidity/utils/Hotdrop";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import Web3 from "web3";

// TODO: set loading state for mint button
// TODO: use an env variable for web3 alchemy socket


export const MintingModal = ({children,isOpen,onClose}) => {
  const [showModal, setShowModal] = useState(isOpen);
  const [totalMints,setTotalMints] =useState(0)
  const { isWeb3Enabled, account } = useMoralis();
  const { fetch: runContractFunction, data, error, isLoading, isFetching, } = useWeb3ExecuteFunction();
  
  const web3 = new Web3('wss://polygon-mumbai.g.alchemy.com/v2/Ffd05GrDEBTQR-htVV9V_hYCLV2HLj9U');

  useEffect(() => {
    async function fetchContractData() {
      const data = await loadContractData();
    }
    fetchContractData();
    // hotdropContractListener();
  }, []);

  const loadContractData = async() => {
    const hotdropContract = await new web3.eth.Contract(HotdropABI,children.hotdropAddress);
    const contractInfo = await hotdropContract.methods.totalSupply(3).call()
    setTotalMints(contractInfo)
  }

  // function hotdropContractListener(){
  // }

  const closeModal = () => {
    setShowModal(false);
    onClose();
  };

  const options = {
    abi: HotdropABI,
    contractAddress: children.hotdropAddress,
    functionName: "saleMint",
    params: {
      amount: 1,
    },
    msgValue: '10000000000000000'
  }

  const mintNFT = async () => {
    if (!isWeb3Enabled) {
      throw "Authentication failed";
    }

    const submitTransaction = await runContractFunction({
      params: options,
      onError: (err) => {
        console.log(err)
      },
      onSuccess: (res) => {
        console.log(res);
      },
    });

    // @ts-ignore
    const contractResult = await submitTransaction.wait();

    console.log('contract result', contractResult);


  }
  {/* <div className="fixed top-0 left-0 w-full h-full bg-gray-900 bg-opacity-75 z-50 flex items-center justify-center">
  <div className="w-1/2 bg-gray-800 rounded-lg shadow-lg p-6">
    <div className="font-bold text-xl mb-2 text-white">{children.artistName} - {children.mediaTitle}</div>

    <div className="flex mb-4">
      <div className="w-1/3 text-gray-300 text-sm font-semibold mr-2">Submitter Wallet:</div>
      <div className="w-2/3 text-gray-300 text-base">[submitter wallet]</div>
    </div>
    <div className="flex mb-4">
      <div className="w-1/3 text-gray-300 text-sm font-semibold mr-2">Song Contract Address:</div>
      <div className="w-2/3 text-gray-300 text-base">[song contract address]</div>
    </div>
    <div className="flex mb-4">

    </div>
    </div>
    </div> */}

  return (
    <div>
      <div className="justify-center items-center flex fixed inset-0 z-50 outline-none focus:outline-none">
        <div className="text-white relative min-w-fit	 my-6 mx-auto max-w-6xl p-80">
          {/*content*/}

          <div className="fixed inset-0 transition-opacity">
            <div className="absolute inset-0 bg-gray-900 opacity-75"></div>
          </div>

          <div className="border-0 rounded-lg shadow-lg relative flex flex-col w-full bg-gray-800 ">
            {/*header*/}
            <div className="flex justify-end p-5 border-b border-solid border-slate-200 rounded-t">
              <button
                className="text-white background-transparent font-bold uppercase px-6 py-2 text-sm outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                type="button"
                onClick={closeModal}
              >
                Close
              </button>
            </div>

            {/*body*/}
            <div className="relative p-6 flex-auto text-white justify-center overflow-hidden pr-20">
              <div className="text-white uppercase text-2xl font-bold mb-4">
                {children.artistName} - {children.mediaTitle}
              </div>
              <div className="flex mb-4">
                <div className="w-1/3 text-gray-300 text-md font-semibold mr-2">Submitter Wallet:</div>
                <div className="w-2/3 text-gray-300 text-base">{children.submitterWallet}</div>
              </div>
              <div className="flex mb-4">
                <div className="w-1/3 text-gray-300 text-sm font-semibold mr-2">Song Contract Address:</div>
                <div className="w-2/3 text-gray-300 text-base">{children.hotdropAddress}</div>
              </div>
              <div className="flex justify-end mt-6">
                <span className="text-xl underline">Units Sold So far: {totalMints} / 25</span>
              </div>
             
            </div>
            {/*footer*/}
            <div className="flex items-center justify-between p-6 rounded-b">
              {children.hotdropAddress == "" ? (
                <button className="w-full text-black px-6 py-3 bg-gray-300 rounded focus:outline-none cursor-not-allowed	" type="button">
                  This contract does not exist
                </button>
              ) : (
                <button
                  className="bg-white w-full text-black active:bg-gray-400 font-bold uppercase text-sm px-6 py-3 rounded-full shadow hover:bg-gray-400 outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                  type="button"
                  onClick={mintNFT}
                >
                  Mint
                </button>
              )}
              {/* <button
                className="bg-emerald-500 text-white active:bg-emerald-600 font-bold uppercase text-sm px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150 opacity-50 cursor-not-allowed"
                type="button"
                // onClick={startAuction}
              >
                Auction (coming soon...)
              </button> */}
            </div>
          </div>
        </div>
      </div>
      <div className="opacity-25 fixed inset-0 z-40 bg-black"></div>
    </div>
    /* <>
  <div className=" bottom-0 inset-x-0 px-4 pb-4 sm:inset-0 sm:flex sm:items-center sm:justify-center">
    
    <div className="fixed inset-0 transition-opacity">
      <div className="absolute inset-0 bg-gray-900 opacity-75"></div>
    </div>

    <div className="bg-gray-800 rounded-lg p-20 overflow-hidden shadow-xl transform transition-all">
   
      <div className="absolute top-0 right-0 -mr-14 p-1">
        <button type="button" className="text-gray-300 hover:text-white focus:text-white focus:outline-none">
          <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"/>
          </svg>
        </button>
      </div> 

    
     <div className="text-white text-2xl font-bold mb-4">{children.artistName} - {children.mediaTitle}</div>
      <div className="flex mb-4">
      <div className="w-1/3 text-gray-300 text-md font-semibold mr-2">Submitter Wallet:</div>
      <div className="w-2/3 text-gray-300 text-base">{children.submitterWallet}</div>
    </div>
    <div className="flex mb-4">
      <div className="w-1/3 text-gray-300 text-sm font-semibold mr-2">Song Contract Address:</div>
      <div className="w-2/3 text-gray-300 text-base">[song contract address]</div>
    </div>
    <div className="flex mb-4">
    <span className="text-2xl font-bold">Units Sold So far: {totalMints}</span> 
    </div>

      <div className="relative rounded-md shadow-sm mt-4">
        <button className="px-4 py-3 font-bold text-white bg-gray-800 rounded-full hover:bg-gray-700 focus:outline-none focus:shadow-outline-gray active:bg-gray-800">
          Mint
        </button>
      </div> 
    </div>
  </div>
  </> */
  );
};
