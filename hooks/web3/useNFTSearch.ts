import React, { useEffect } from "react";
import { usePhlote } from "./usePhlote";
import FuzzySearch from "fuzzy-search";
import { atom, useAtom } from "jotai";
import { ArchiveCuration } from "../../types/curations";

const searchNFTsAtom = atom<ArchiveCuration[]>([]);
export const useSearchNFTs = () => useAtom(searchNFTsAtom);

export const useGetAllNFTs = () => {
  const [nfts, setNFTs] = useSearchNFTs();

  const phlote = usePhlote();

  React.useEffect(() => {
    const getContent = () => {
      phlote.getAllCurations().then((content) => {
        const reversed = ([...content] as ArchiveCuration[]).reverse();
        setNFTs(reversed);
      });
    };

    if (phlote) {
      getContent();
      phlote.on("*", (res) => {
        if (res.event === "EditionCreated") {
          getContent();
        }
      });
    }

    return () => {
      phlote?.removeAllListeners();
    };
  }, [phlote, setNFTs]);

  return nfts;
};

export const useNFTSearch = (searchTerm = "") => {
  const nfts = useGetAllNFTs();
  const searcher = new FuzzySearch(nfts);
  return searcher.search(searchTerm + " ") as ArchiveCuration[];
};
