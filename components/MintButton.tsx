import React, { useState } from "react";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import { HotdropABI } from "../solidity/utils/Hotdrop";
import { toast } from "react-toastify";

interface Props {
  hotdropAddress: string;
  color: string;
  text: string;
  hoverColor?: string;
  onClick?: () => void;
}

const MintButton: React.FC<Props> = ({ hotdropAddress, color, text, hoverColor, onClick }) => {
  const { fetch: runContractFunction, data, error, isLoading, isFetching } = useWeb3ExecuteFunction();
  const { isWeb3Enabled, account } = useMoralis();
  // isLoading: user action required - (metamask popup open)
  const [loading, setLoading] = useState<boolean | string>(false);
  // const [allowedToDownload, setAllowedToDownload] = useState(false);

  // TODO: add msgValue to our constants (all of our sales will be at this price)
  const options = {
    abi: HotdropABI,
    contractAddress: hotdropAddress,
    functionName: "saleMint",
    params: {
      amount: 1,
    },
    msgValue: "10000000000000000",
  };

  const mintNFT = async () => {
    if (!isWeb3Enabled) {
      throw "Authentication failed";
    }

    setLoading("Loading Transaction");

    const submitTransaction = await runContractFunction({
      params: options,
      onError: (err) => {
        setLoading(false);
        console.log(err);
        toast.error('Failed to mint! \n' + err.message)
      },
      onSuccess: (res) => {
        console.log(res);
        toast.success('Minted!');
      },
    });

    const contractResult = await submitTransaction;
    console.log("mint contract result", contractResult);

    setLoading(false);
  };

  if (!loading) {
    return (
      <button className="bg-indigo-500 text-white py-2 px-4 rounded-lg hover:bg-indigo-600" onClick={mintNFT}>
        Mint
      </button>

    );
  } else {
    return (
      <button
        className={`${color} inline-flex h-10 items-center text-white py-2 px-4 rounded-lg ml-2 ${hoverColor ? `hover:${hoverColor}` : ``} ${
          isLoading ? "loading-spinner" : ""
        } cursor-not-allowed`}
        onClick={onClick}
        disabled={isLoading}
      >
        <svg className="w-5 h-5 mr-3 -ml-1 text-white animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
          <path
            className="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          ></path>
        </svg>
        <span className={`${isLoading ? "text-current" : ""}`}> {text} </span>
      </button>
    );
  }
};

export default MintButton;
