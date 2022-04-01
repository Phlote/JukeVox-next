import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import Image from "next/image";
import React from "react";
import { useKeyPress } from "../hooks/useKeyPress";
import Close from "../public/close.svg";
import { Injected } from "../utils/connectors";
import { HollowInput, HollowInputContainer } from "./Hollow";

const searchTermAtom = atom<string>("");
export const useSearchTerm = () => useAtom(searchTermAtom);

interface SearchBar {
  placeholder?: string;
}

export const SearchBar: React.FC<SearchBar> = ({ placeholder }) => {
  const { active, activate } = useWeb3React();
  const [searchTerm, setSearchTerm] = useSearchTerm();
  const inputRef = React.useRef(null);

  useKeyPress("Escape", () => {
    if (inputRef.current === document.activeElement) setSearchTerm("");
  });

  return (
    <div className="w-80 h-16" style={{ lineHeight: "0.5rem" }}>
      <HollowInputContainer
        onClick={() => {
          if (active) inputRef.current.focus();
          else activate(Injected, undefined, true);
        }}
      >
        <Image height={30} width={30} src="/search.svg" alt="search" />
        <HollowInput
          ref={inputRef}
          type="text"
          onChange={(e) => {
            const { value } = e.target;
            setSearchTerm(value);
          }}
          value={searchTerm}
          disabled={!active}
          placeholder={active ? placeholder : "Connect your wallet to search"}
        />
        {searchTerm && (
          <div
            className="w-4 h-4 cursor-pointer  flex items-center justify-center"
            onClick={() => setSearchTerm("")}
          >
            <Close fill="white" />
          </div>
        )}
      </HollowInputContainer>
    </div>
  );
};
