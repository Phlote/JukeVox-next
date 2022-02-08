import { atom, useAtom } from "jotai";
import styled from "styled-components";
import React from "react";

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

const submitSidenavOpen = atom<boolean>(false);
export const useSubmitSidenavOpen = () => useAtom(submitSidenavOpen);

export const SubmitSidenav = (props) => {
  const [curationFormData, setCurationFormData] =
    React.useState<CurationMetadata>();

  const updateSubmission = (update: Partial<CurationMetadata>) => {
    setCurationFormData((curr) => {
      return { ...curr, ...update };
    });
  };

  const [open] = useSubmitSidenavOpen();

  if (!open) return null;

  return (
    <SidenavContainer>
      {/* <div className="mb-4">
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
      </div> */}
    </SidenavContainer>
  );
};

export const SidenavContainer = (props) => {
  const [open, setOpen] = useSubmitSidenavOpen();

  return (
    <div
      className="w-96 flex flex-column h-full absolute z-10 right-0"
      style={{ backgroundColor: "#1E1E1E" }}
    >
      <div
        onClick={() => {
          setOpen(false);
        }}
        className="absolute top-1 left-2"
      >{`<-`}</div>
    </div>
  );
};
