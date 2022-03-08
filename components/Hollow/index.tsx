import tw from "twin.macro";
import styled from "styled-components";

export const HollowButtonContainer = styled.div`
  background: ${(props) => props.backgroundColor ?? "rgba(0, 0, 0, 0.47)"};

  color: white;
  padding: 1rem;
  border-radius: 9999px;

  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  max-height: 3.75rem;
  border: 1px white solid;

  &:focus {
    outline: none;
  }
`;

export const HollowInputContainer = styled.div(({ type }) => [
  tw`bg-phlote-container text-white p-4 rounded-full flex flex-grow flex-row items-center justify-start`,
  type === "form" && tw`border border-white max-h-14`,
]);

export const HollowInput = styled.input`
  background-color: transparent;
  opacity: 100%;
  color: white;
  flex-grow: 1;
  max-width: 100%;
  outline: none;
  border: none;
  padding-left: 1rem;

  &:focus {
    outline: none;
  }

  &:-webkit-autofill,
  &:-webkit-autofill:focus {
    transition: background-color 600000s 0s, color 600000s 0s;
  }

  &::placeholder {
    color: white;
  }
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
