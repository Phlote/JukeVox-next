import { atom, useAtom } from "jotai";
import styled from "styled-components";
import React from "react";
import { HollowInputContainer, HollowInput } from "./Hollow";
import { CurationSubmissionForm } from "./CurationSubmissionForm";
import Image from "next/image";

const submitSidenavOpen = atom<boolean>(true);
export const useSubmitSidenavOpen = () => useAtom(submitSidenavOpen);

export const SubmitSidenav = (props) => {
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
      className="w-96 flex flex-column overflow-y-scroll absolute z-10 right-0"
      style={{ backgroundColor: "#1E1E1E" }}
    >
      <div
        onClick={() => {
          setOpen(false);
        }}
        className="absolute top-3 left-3 cursor-pointer"
      >
        <Image src={"/chevron.svg"} alt="close" height={16} width={16} />
      </div>
      {children}
    </div>
  );
};
