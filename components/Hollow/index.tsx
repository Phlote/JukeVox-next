import styled from "styled-components";
import tw from "twin.macro";

export const HollowButtonContainer = styled.div`
  ${tw`bg-phlote-button text-white rounded-full flex p-4 flex-row items-center justify-center border border-white max-h-14`}
  &:hover {
    opacity: 75%;
  }
`;

export const HollowButton = styled.button(({ submitting }) => [
  tw`bg-transparent opacity-100 text-white  max-w-full  h-full outline-none border-none text-center`,
  `
  &:disabled {
    opacity: 50%;
  }
  `,
]);

export const HollowInputContainer = styled.div(({ type }) => [
  tw`bg-phlote-container text-white p-4 rounded-full flex flex-grow flex-row items-center justify-start`,
  type === "form" && tw`border border-white max-h-14`,
]);

export const HollowInput = styled.input`
  ${tw`bg-transparent opacity-100 text-white flex-grow max-w-full outline-none border-none pl-4`}
  &:-webkit-autofill,
  &:-webkit-autofill:focus {
    transition: background-color 600000s 0s, color 600000s 0s;
  }

  &::placeholder {
    color: white;
    opacity: 50%;
  }
`;
