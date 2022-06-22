import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import debounce from "lodash.debounce";
import Image from "next/image";
import { useRouter } from "next/router";
import React from "react";
import { useKeyPress } from "../hooks/useKeyPress";
import { HollowInput, HollowInputContainer } from "./Hollow";
import { useConnectWalletModalOpen } from "./Modals/ConnectWalletModal";

const searchTermAtom = atom<string>("");
export const useSearchTerm = () => useAtom(searchTermAtom);

interface SearchBar {
  placeholder?: string;
}

export const SearchBar: React.FC<SearchBar> = ({ placeholder }) => {
  const { active } = useWeb3React();
  const [searchTerm, setSearchTerm] = useSearchTerm();
  const router = useRouter();

  const [inputVal, setInputVal] = React.useState<string>(
    (router.query.search as string) || ""
  );
  const inputRef = React.useRef(null);

  const [open, setOpen] = useConnectWalletModalOpen();

  useKeyPress("Escape", () => {
    if (inputRef.current === document.activeElement) setSearchTerm("");
  });

  // If we are at the home page, cancel out search
  React.useEffect(() => {
    if (router.pathname === "/") setInputVal("");
  }, [router.pathname, setSearchTerm]);

  // debounce updating the atom
  // eslint-disable-next-line react-hooks/exhaustive-deps
  const onInputValChange = React.useCallback(
    debounce((value) => setSearchTerm(value), 300),
    []
  );

  // when he input value changes, call our debounced on change handler
  React.useEffect(() => {
    onInputValChange(inputVal);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [inputVal]);

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
          value={inputVal}
          type="search"
          onChange={(e) => {
            setInputVal(e.target.value);
          }}
          disabled={!active}
          placeholder={active ? placeholder : "Connect your wallet to search"}
        />
      </HollowInputContainer>
    </div>
  );
};
