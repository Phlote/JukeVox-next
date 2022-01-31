import React from "react";

export interface CurationMetadata {
  artistName: string;
  trackTitle: string;
  tags?: string[];
  curatorName?: string;
  curatorWallet: string;
  submissionTimestamp: string;
  uuid: string;
}

export const CuratorSubmissionModal: React.FC<{ open: boolean }> = (props) => {
  const curationFormData = React.useState<CurationMetadata>();

  return (
    <div className="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 max-w-lg">
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          What kind of media are you submitting?
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
        />
      </div>
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          {"Artist's name"}
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
        />
      </div>
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          Title
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
        />
      </div>
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          Add URL for NFT below
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
        />
      </div>
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          NFT Contract Address
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
        />
      </div>
      <div className="mb-4">
        {/* TODO this should work like other tag systems */}
        <label className="block text-gray-700 text-sm font-bold mb-2">
          Add Tags
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
        />
      </div>
      <div className="mb-6 flex justify-center">
        <button
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
          type="button"
          onClick={() =>
            alert("TODO: prompt user to approve and sign transaction")
          }
        >
          Mint
        </button>
      </div>
    </div>
  );
};
