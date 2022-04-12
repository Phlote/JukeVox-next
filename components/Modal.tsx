import React from "react";
import styled from "styled-components";
import tw from "twin.macro";

interface ModalProps {
  open: boolean;
  onClose?: () => void;
  children: React.ReactNode;
  width?: string;
}

export const Modal: React.FC<ModalProps> = ({
  children,
  open,
  onClose,
  width,
  height,
}) => {
  return (
    <div
      className="flex w-screen h-screen absolute z-20 justify-center items-center"
      style={!open ? { display: "none" } : undefined}
    >
      {open && (
        <div
          className="opacity-0 flex-grow min-h-full min-w-full -z-10"
          onClick={onClose}
        ></div>
      )}

      <ModalContainer width={width} height={height}>
        {children}
      </ModalContainer>
    </div>
  );
};

const ModalContainer = styled.div`
  ${tw`absolute text-white p-4 bg-phlote-ff-modal`}
  width: ${(props) => (props.width ? props.width : "60rem")};
  height: ${(props) => (props.height ? props.height : "32rem")};
  border-radius: 100px;
  @supports (backdrop-filter: none) {
    background: linear-gradient(
        85.96deg,
        rgba(255, 255, 255, 0) -20.51%,
        rgba(255, 255, 255, 0.05) 26.82%,
        rgba(255, 255, 255, 0) 65.65%
      ),
      rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(37.5367px);
    box-shadow: inset 0px -2.50245px 1.25122px rgba(255, 255, 255, 0.1);
  }
`;
