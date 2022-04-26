import Image from "next/image";
import React from "react";
import styled from "styled-components";
import tw from "twin.macro";
import { SubmissionFlow, useSubmissionFlowOpen } from "./SubmissionFlow";

export const SubmitSidenav = (props) => {
  const [open, setOpen] = useSubmissionFlowOpen();

  return (
    <SideNav onClose={() => setOpen(false)} open={open}>
      <SubmissionFlow />
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
          className="opacity-0 flex-grow min-h-full z-20"
          onClick={onClose}
        ></div>
      )}

      <SideNavContainer>
        <div className="flex flex-row h-full w-full">
          <div
            onClick={onClose}
            className="absolute top-8 left-4 cursor-pointer"
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
  ${tw`h-screen z-10 overflow-y-scroll flex-none bg-phlote-ff-sidenav`}
  width: 27rem;
  @supports (backdrop-filter: none) {
    background-color: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(60px);
  }
`;
