import React, {useState } from "react";

export const MintingModal = ({children,isOpen,onClose}) => {
  const [showModal, setShowModal] = useState(isOpen);


  const closeModal = () => {
    setShowModal(false);
    onClose();
  };
 
  const mintNFT = () => {
    console.log("lets mint you one")
  }

  return (
    <div>
      <div className="justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
        <div className="text-white relative w-auto my-6 mx-auto max-w-6xl">
          {/*content*/}
         
          <div className="border-0 rounded-lg shadow-lg relative flex flex-col w-full bg-neutral-700 outline-none focus:outline-none">
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
            <div className="relative p-6 flex-auto text-white flex flex-row justify-center gap-28">
              <p className="m-auto text-white text-lg flex flex-col">
                <ol>
                    <li><span className="text-2xl font-bold">Artist Name:</span> {children.artistName}</li>
                    <li><span className="text-2xl font-bold">Song Name:</span> {children.mediaTitle}</li>
                    <li><span className="text-2xl font-bold">Submitter Wallet:</span> {children.submitterWallet}</li>
                    <li><span className="text-2xl font-bold">Song contract address:</span> {children.hotdropAddress == "" ? "This song does not have a contract address...": children.hotdropAddress}</li>
                </ol>
            </p>
            </div>
            {/*footer*/}
            <div className="flex items-center justify-between p-6 rounded-b">
              <button
                className="bg-emerald-500 text-white active:bg-emerald-600 font-bold uppercase text-sm px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                type="button"
                onClick={mintNFT}
              >
                Mint
              </button>
              <button
                className="bg-emerald-500 text-white active:bg-emerald-600 font-bold uppercase text-sm px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150 opacity-50 cursor-not-allowed"
                type="button"
                // onClick={startAuction}
              >
                Auction (coming soon...)
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className="opacity-25 fixed inset-0 z-40 bg-black"></div>
    </div>
  );
};
