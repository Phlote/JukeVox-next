import tw from "twin.macro";
import styled from "styled-components";

export const HollowButtonContainer = tw.div`bg-phlote-container text-white p-4 rounded-full flex flex-row items-center justify-center border border-white max-h-14`;

export const HollowInputContainer = styled.div(({ type }) => [
  tw`bg-phlote-container text-white p-4 rounded-full flex flex-grow flex-row items-center justify-start`,
  type === "form" && tw`border border-white max-h-14`,
]);

// export const HollowInput = styled.input`
//   background-color: transparent;
//   opacity: 100%;
//   color: white;
//   flex-grow: 1;
//   max-width: 100%;
//   outline: none;
//   border: none;
//   padding-left: 1rem;

//   &:focus {
//     outline: none;
//   }
// `;

export const HollowInput = styled.input`
  &:-webkit-autofill,
  &:-webkit-autofill:focus {
    transition: background-color 600000s 0s, color 600000s 0s;
  }

  &::placeholder {
    color: white;
  }
  ${tw`bg-transparent opacity-100 text-white flex-grow max-w-full outline-none pl-4`}
`;

export const HollowButton = styled.button`
  background-color: transparent;
  opacity: 100%;
  color: white;
  flex-grow: 1;
  max-width: 100%;
  outline: none;
  border: none;
  text-align: center;

  &:focus {
    outline: none;
  }

  &:disabled {
    opacity: 50%;
  }
`;
