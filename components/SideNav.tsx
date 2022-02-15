import { atom, useAtom } from "jotai";
import styled from "styled-components";
import React from "react";
import { HollowInputContainer, HollowInput } from "./Hollow";
import Image from "next/image";
import { CurationSubmissionFlow } from "./CurationSubmissionFlow";

const submitSidenavOpen = atom<boolean>(false);
export const useSubmitSidenavOpen = () => useAtom(submitSidenavOpen);

export const SubmitSidenav = (props) => {
  const [open] = useSubmitSidenavOpen();

  if (!open) return null;

  return (
    <SidenavContainer>
      <CurationSubmissionFlow />
    </SidenavContainer>
  );
};

export const SidenavContainer = ({ children }) => {
  const [open, setOpen] = useSubmitSidenavOpen();

  return (
    <div className="h-screen absolute z-10 right-0 overflow-y-scroll">
      <div
        className="flex flex-column min-h-screen"
        style={{ backgroundColor: "#1E1E1E", width: "27rem" }}
      >
        <div
          onClick={() => {
            setOpen(false);
          }}
          className="absolute top-16 left-4 cursor-pointer"
        >
          <Image src={"/chevron.svg"} alt="close" height={16} width={16} />
        </div>
        {children}
      </div>
    </div>
  );
};
