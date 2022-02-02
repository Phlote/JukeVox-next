import React from "react";
import { Modal } from "./Modal";

export interface CurationMetadata {
  artistName: string;
  trackTitle: string;
  nftURL: string;
  nftContractAddress: string;
  tags?: string[];
  curatorName?: string;
  curatorWallet: string;
  submissionTimestamp?: string;
  uuid?: string;
}

export const CuratorSubmissionModal: React.FC<{
  open: boolean;
  setOpen: (b: boolean) => void;
}> = (props) => {
  const { open, setOpen } = props;
  const [curationFormData, setCurationFormData] =
    React.useState<CurationMetadata>();

  const updateSubmission = (update: Partial<CurationMetadata>) => {
    setCurationFormData((curr) => {
      return { ...curr, ...update };
    });
  };

  return (
    <Modal open={open} onClose={() => setOpen(false)}>
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
          onChange={(e) =>
            updateSubmission({
              artistName: e.target.value,
            })
          }
        />
      </div>
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          Title
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
          onChange={(e) =>
            updateSubmission({
              trackTitle: e.target.value,
            })
          }
        />
      </div>
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          Add URL for NFT below
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
          onChange={(e) =>
            updateSubmission({
              nftURL: e.target.value,
            })
          }
        />
      </div>
      <div className="mb-4">
        <label className="block text-gray-700 text-sm font-bold mb-2">
          NFT Contract Address
        </label>
        <input
          className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          type="text"
          onChange={(e) =>
            updateSubmission({
              nftContractAddress: e.target.value,
            })
          }
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
            alert(
              ` TODO: prompt user to approve and sign transaction\n ${JSON.stringify(
                curationFormData,
                null,
                4
              )}`
            )
          }
        >
          Mint
        </button>
      </div>
    </Modal>
  );
};
