import { atom, useAtom } from "jotai";
import { HollowInputContainer, HollowInput } from "./Hollow";
import Image from "next/image";
import React from "react";
import { useWeb3React } from "@web3-react/core";
import { injected } from "../connectors";

const searchTermAtom = atom<string>("");
export const useSearchTerm = () => useAtom(searchTermAtom);

interface SearchBar {
  placeholder?: string;
}

export const SearchBar: React.FC<SearchBar> = ({ placeholder }) => {
  const { active, activate } = useWeb3React();
  const [searchTerm, setSearchTerm] = useSearchTerm();
  const inputRef = React.useRef(null);

  return (
    <div className="w-80 h-16" style={{ lineHeight: "0.5rem" }}>
      <HollowInputContainer
        onClick={() => {
          if (active) inputRef.current.focus();
          else activate(injected, undefined, true);
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
          placeholder={active ? placeholder : "Connect your wallet to search"}
        />
      </HollowInputContainer>
    </div>
  );
};
