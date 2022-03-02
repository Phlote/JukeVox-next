import React, { useEffect } from "react";
import { usePhlote } from "./usePhlote";
import FuzzySearch from "fuzzy-search";
import { atom, useAtom } from "jotai";
import { ArchiveCuration } from "../../types/curations";

const searchNFTsAtom = atom<ArchiveCuration[]>([]);
export const useSearchNFTs = () => useAtom(searchNFTsAtom);

export const useGetAllNFTs = () => {
  // TODO: caching?
  const [nfts, setNFTs] = useSearchNFTs();

  const phlote = usePhlote();

  React.useEffect(() => {
    const getContent = () => {
      phlote.getAllCurationsAgainButWithASmallChange().then((content) => {
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

const NFTSearchFiltersAtom = atom<Partial<ArchiveCuration>>({});
export const useNFTSearchFilters = () => useAtom(NFTSearchFiltersAtom);

const isPartialMatch = (
  curation: ArchiveCuration,
  filters: Partial<ArchiveCuration>
) => {
  return Object.keys(filters).reduce((acc, key) => {
    return acc && filters[key] === curation[key];
  }, true);
};

export const useNFTSearch = (searchTerm = "") => {
  const nfts = useGetAllNFTs();
  const [filters] = useNFTSearchFilters();
  const searcher = new FuzzySearch(nfts);
  const searchResults = searcher.search(searchTerm + " ");
  const filtered = searchResults
    .map((result) => {
      if (isPartialMatch(result, filters)) return result;
      else return null;
    })
    .filter((n) => n);

  return filtered as ArchiveCuration[];
};
