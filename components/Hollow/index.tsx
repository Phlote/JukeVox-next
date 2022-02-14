import styled from "styled-components";

export const HollowButtonContainer = styled.div`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  padding: 1rem;
  border-radius: 9999px;

  display: flex;
  flex-grow: 1;
  flex-direction: row;
  align-items: center;
  justify-content: center;

  &:focus {
    outline: none;
  }
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
  max-height: 3.75rem;

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
