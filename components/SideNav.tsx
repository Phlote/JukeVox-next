import { atom, useAtom } from "jotai";
import styled from "styled-components";
import React from "react";
import { HollowInputContainer, HollowInput } from "./Hollow";
import { CurationSubmissionForm } from "./CurationSubmissionForm";

// export interface CurationMetadata {
//   artistName: string;
//   trackTitle: string;
//   nftURL: string;
//   nftContractAddress: string;
//   tags?: string[];
//   curatorName?: string;
//   curatorWallet: string;
//   submissionTimestamp?: string;
//   uuid?: string;
// }

const submitSidenavOpen = atom<boolean>(true);
export const useSubmitSidenavOpen = () => useAtom(submitSidenavOpen);

export const SubmitSidenav = (props) => {
  const updateSubmission = (update: Partial<CurationMetadata>) => {
    setCurationFormData((curr) => {
      return { ...curr, ...update };
    });
  };

  const [open] = useSubmitSidenavOpen();

  if (!open) return null;

  return (
    <SidenavContainer>
      <CurationSubmissionForm />
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
