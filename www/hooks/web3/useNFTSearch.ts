import React, { useEffect } from "react";
import { usePhlote } from "./usePhlote";
import FuzzySearch from "fuzzy-search";
import { atom, useAtom } from "jotai";
import { ArchiveCuration } from "../../types/curations";

export const useAllSubmissions = () => {
  // TODO: caching?
  const [submissions, setSubmissions] = React.useState<ArchiveCuration[]>([]);

  const phlote = usePhlote();

  React.useEffect(() => {
    const getContent = () => {
      phlote.getAllCurations().then((content) => {
        const reversed = ([...content] as ArchiveCuration[]).reverse();
        setSubmissions(reversed);
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
  }, [phlote, setSubmissions]);

  return { submissions, setSubmissions };
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
  const { submissions } = useAllSubmissions();
  const [filters] = useNFTSearchFilters();
  const searcher = new FuzzySearch(submissions);
  const searchResults = searcher.search(searchTerm.trim());

  const filtered = searchResults
    .map((result) => {
      if (isPartialMatch(result, filters)) return result;
      else return null;
    })
    .filter((n) => n);

  return filtered as ArchiveCuration[];
};
