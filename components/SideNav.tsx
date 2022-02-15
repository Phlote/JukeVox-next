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
    <Sidenav>
      <CurationSubmissionFlow />
    </Sidenav>
  );
};

export const Sidenav = ({ children }) => {
  const [open, setOpen] = useSubmitSidenavOpen();

  return (
    <SideNavContainer>
      <div className="flex flex-column min-h-screen">
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
    </SideNavContainer>
  );
};

const SideNavContainer = styled.div`
  height: 100vh;
  position: absolute;
  z-index: 10;
  right: 0;
  overflow-y: scroll;
  width: 27rem;
  background-color: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(60px);
`;
