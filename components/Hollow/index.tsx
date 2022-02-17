import styled from "styled-components";

export const HollowButtonContainer = styled.div`
  background: ${(props) => props.backgroundColor ?? "rgba(0, 0, 0, 0.47)"};

  color: white;
  padding: 1rem;
  border-radius: 9999px;

  display: flex;
  flex-grow: 1;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  max-height: 3.75rem;
  border: 1px white solid;

  &:focus {
    outline: none;
  }
`;

export const HollowTableRow = styled.tr`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  /* padding: 1rem; */
  margin-top: 1rem;
  margin-bottom: 1rem;
  height: 3.5rem;
  align-items: center;

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 999px 0 0 999px;
  }
  /* &:first-child td:last-child {
    border-top-right-radius: 999px;
  }
  &:last-child td:first-child {
    border-bottom-left-radius: 999px;
  }
  &:last-child td:last-child {
    border-bottom-right-radius: 999px;
  } */
`;

export const HollowInputContainer = styled.div`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  padding: 1rem;
  border-radius: 9999px;

  display: flex;
  flex-grow: 1;
  flex-direction: row;
  align-items: center;
  justify-content: left;
  max-height: ${(props) => props.type === "form" && "3.5rem"};
  border: ${(props) => props.type === "form" && "1px white solid"};

  &:focus {
    outline: none;
  }
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

  &::placeholder {
    color: white;
  }
`;
