import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import debounce from "lodash.debounce";
import Image from "next/image";
import { useRouter } from "next/router";
import React, { useCallback } from "react";
import { useKeyPress } from "../hooks/useKeyPress";
import { HollowInput, HollowInputContainer } from "./Hollow";
import { useConnectWalletModalOpen } from "./Modals/ConnectWalletModal";

const searchTermAtom = atom<string>("");
export const useSearchTerm = () => useAtom(searchTermAtom);

interface SearchBar {
  placeholder?: string;
}

export const SearchBar: React.FC<SearchBar> = ({ placeholder }) => {
  const { active, activate } = useWeb3React();
  const [searchTerm, setSearchTerm] = useSearchTerm();
  const inputRef = React.useRef(null);
  const router = useRouter();

  const [open, setOpen] = useConnectWalletModalOpen();

  useKeyPress("Escape", () => {
    if (inputRef.current === document.activeElement) setSearchTerm("");
  });

  React.useEffect(() => {
    if (router.pathname === "/") setSearchTerm("");
  }, [router.pathname, setSearchTerm]);

  const onChange = (e) => {
    const { value } = e.target;
    setSearchTerm(value);
  };

  // eslint-disable-next-line react-hooks/exhaustive-deps
  const debouncedOnChange = useCallback(debounce(onChange, 300), []);

  return (
    <div className="w-80 h-16" style={{ lineHeight: "0.5rem" }}>
      <HollowInputContainer
        onClick={() => {
          if (active) inputRef.current.focus();
          else setOpen(true);
        }}
      >
        <Image height={30} width={30} src="/search.svg" alt="search" />
        <HollowInput
          ref={inputRef}
          type="search"
          onChange={debouncedOnChange}
          disabled={!active}
          placeholder={active ? placeholder : "Connect your wallet to search"}
        />
      </HollowInputContainer>
    </div>
  );
};
