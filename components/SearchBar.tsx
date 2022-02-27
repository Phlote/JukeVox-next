import { atom, useAtom } from "jotai";
import { HollowInputContainer, HollowInput } from "./Hollow";
import Image from "next/image";

const searchTermAtom = atom<string>("");
export const useSearchTerm = () => useAtom(searchTermAtom);

interface SearchBar {
  placeholder?: string;
}

export const SearchBar: React.FC<SearchBar> = ({ placeholder }) => {
  const [searchTerm, setSearchTerm] = useSearchTerm();

  return (
    <div className="w-1/4 h-16" style={{ lineHeight: "0.5rem" }}>
      <HollowInputContainer
        onClick={() => {
          //TODO fix ID thing here, ref?
          document.getElementById("search").focus();
        }}
      >
        <Image height={30} width={30} src="/search.svg" alt="search" />
        <HollowInput
          id="search"
          className="ml-4 flex-grow"
          type="text"
          onChange={(e) => {
            const { value } = e.target;
            setSearchTerm(value);
          }}
          value={searchTerm}
          placeholder={placeholder}
        />
      </HollowInputContainer>
    </div>
  );
};
