import styled from "styled-components";

export const LineInputContainer = styled.div`
  color: ${(props) => props.primary ?? "white"};

  display: flex;
  position: relative;
  margin-bottom: 1rem;
  width: 100%;

  &:focus {
    outline: none;
  }

  &::placeholder {
    color: ${(props) => props.secondary ?? "white"};
  }
`;
export const LineInput = styled.input`
  background-color: transparent;
  color: ${(props) => props.primary ?? "white"};

  flex-grow: 1;

  outline: none;
  border: none;
  border-bottom: 1px solid #312437;
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 3rem;
  width: 5rem;
  font-size: 1.5rem;

  &:focus {
    outline: none;
    /* border-bottom: 1px solid ${(props) => props.secondary}; */
  }

  &::placeholder {
    color: ${(props) => props.secondary ?? "white"};
  }
`;
