import { atom, useAtom } from "jotai";
import styled from "styled-components";
import React from "react";
import { HollowInputContainer, HollowInput } from "./Hollow";
import Image from "next/image";
import { CurationSubmissionFlow } from "./CurationSubmissionFlow";

const submitSidenavOpen = atom<boolean>(false);
export const useSubmitSidenavOpen = () => useAtom(submitSidenavOpen);

export const SubmitSidenav = (props) => {
  const [open, setOpen] = useSubmitSidenavOpen();

  return (
    <SideNav onClose={() => setOpen(false)} open={open}>
      <CurationSubmissionFlow />
    </SideNav>
  );
};

export const SideNav = ({ children, onClose, open }) => {
  return (
    <div
      className="flex w-screen h-screen fixed z-20"
      style={!open ? { display: "none" } : undefined}
    >
      {open && (
        <div
          className="opacity-0  flex-grow min-h-full z-20"
          onClick={onClose}
        ></div>
      )}

      <SideNavContainer>
        <div className="flex flex-row flex-column h-full w-full">
          <div
            onClick={onClose}
            className="absolute top-16 left-4 cursor-pointer"
          >
            <Image src={"/chevron.svg"} alt="close" height={16} width={16} />
          </div>
          {children}
        </div>
      </SideNavContainer>
    </div>
  );
};

const SideNavContainer = styled.div`
  height: 100vh;
  z-index: 10;
  overflow-y: scroll;
  width: 27rem;

  background: #1d1d1d;
  @supports (backdrop-filter: none) {
    background-color: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(60px);
  }

  flex: none;
`;
