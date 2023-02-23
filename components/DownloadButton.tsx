import React, { useState, useEffect } from "react";
import { useMoralis, useWeb3ExecuteFunction } from "react-moralis";
import { HotdropABI } from "../solidity/utils/Hotdrop";
import { AbiItem } from "web3-utils";
import { Web3_Socket_URL } from "../utils/constants";
import { supabase } from "../lib/supabase";
import Web3 from "web3";


interface Props {
  hotdropAddress: string;
  id: string;
  text: string;
  onClick?: () => void;
}

const DownloadButton: React.FC<Props> = ({ id, hotdropAddress, text, onClick }) => {
    const { isWeb3Enabled, account } = useMoralis();
    const [isButtonDisabled, setIsButtonDisabled] = useState(false);
    const [downloadableLink, setDownloadableLink] = useState(null)


    useEffect(() => {
     
      const updateButtonState = async () => {
        if(account){
          const res = await checkHasDownloadables();
          console.log(res)
          /*
            - If submission does not have downloadable link, turn off the button
          */
          if(!res){
            setIsButtonDisabled(true);
          }
          else{
            setIsButtonDisabled(!(await isAllowedToDownload()));
          }
          
        }
      };
      updateButtonState();
    }, [account]);

    const isAllowedToDownload = async () => {
      const web3 = new Web3(Web3_Socket_URL);
      const hotdropContract = new web3.eth.Contract(HotdropABI as unknown as AbiItem, hotdropAddress);
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

    async function checkHasDownloadables(){
      const current_submission = await supabase.from('Artist_Submission_Table').select('*').eq("submissionID",`${id}`)
      const downloadableLink = current_submission.data[0].downloadable_assets
      console.log(current_submission.data[0])
      if(downloadableLink != null){
        setDownloadableLink(downloadableLink);
        return true
      }
      else{
        return false
      }
    }

    const handleDownload = async (e) => {
      e.preventDefault();

      if (account && downloadableLink != null) {
        const isAllowed = await isAllowedToDownload();
        if (isAllowed) {
          window.open(downloadableLink, "_blank");
        }
      }
    };

  return (
    <button
      className={`w-full bg-indigo-500 text-white py-2 px-4 rounded-lg
      ${isButtonDisabled ? 'opacity-50 cursor-not-allowed' : 'hover:bg-indigo-600'}`}
      onClick={handleDownload}
      disabled={isButtonDisabled}
    >
      {text}
    </button>
  );
};

export default DownloadButton;
