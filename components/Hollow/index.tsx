import tw, { styled } from "twin.macro";

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

// export const HollowInputContainer = styled.div`
//   ${tw`bg-phlote-container text-white p-4 rounded-full flex flex-grow flex-row items-center justify-start`};

//  background: ${(props) =>
//     props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};
//   color: white;
//   padding: 1rem;
//   border-radius: 9999px;
//   display: flex;
//   flex-grow: 1;
//   flex-direction: row;
//   align-items: center;
//   justify-content: left;

//    max-height: ${(props) => props.type === "form" && "3.5rem"};
//   border: ${(props) => props.type === "form" && "1px white solid"};
// `;

// export const HollowInputContainer = styled.div(({ form }) => [
//   // form ? max
//   tw`
//   bg-phlote-container text-white p-4 rounded-full flex flex-grow flex-row items-center justify-start
//   `,
// ]);

export const HollowInputContainer = tw.div`
bg-phlote-container text-white p-4 rounded-full flex flex-grow flex-row items-center justify-start
`;

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
