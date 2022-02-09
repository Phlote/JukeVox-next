import { atom, useAtom } from "jotai";
import styled from "styled-components";
import React from "react";
import { HollowInputContainer, HollowInput } from "./HollowInput";

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

const submitSidenavOpen = atom<boolean>(true);
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
      <div className="flex flex-col mx-auto w-4/5">
        <h1 className="text-center my-8 text-4xl underline-offset-8	underline">
          Submit
        </h1>
        <div className="h-4"></div>
        {/* todo dropdown */}
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            className="flex-grow"
            type="text"
            placeholder="Media Type"
          />
        </HollowInputContainer>
        <div className="h-4" />
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            className="flex-grow"
            type="text"
            placeholder="Artist Name"
          />
        </HollowInputContainer>
        <div className="h-4" />

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            className="flex-grow"
            type="text"
            placeholder="Artist Wallet Address"
          />
        </HollowInputContainer>
        <div className="h-4" />

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            className="flex-grow"
            type="text"
            placeholder="Song Title"
          />
        </HollowInputContainer>
        <div className="h-4" />

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            className="flex-grow"
            type="text"
            placeholder="URL of NFT"
          />
        </HollowInputContainer>
        <div className="h-4" />

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            className="flex-grow"
            type="text"
            placeholder="Marketplace (i.e. OpenSea, Zora)"
          />
        </HollowInputContainer>
        <div className="h-4" />

        {/* TODO: tag system */}
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput className="flex-grow" type="text" placeholder="Tags" />
        </HollowInputContainer>
      </div>
    </SidenavContainer>
  );
};

export const SidenavContainer = ({ children }) => {
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
      {children}
    </div>
  );
};
