import FuzzySearch from "fuzzy-search";
import { atom, useAtom } from "jotai";
import React from "react";
import { ArchiveCuration } from "../../types/curations";
import { usePhlote } from "./usePhlote";

const submissionsAtom = atom<ArchiveCuration[]>([]);

export const useAllSubmissions = () => {
  // TODO: caching?
  const [submissions, setSubmissions] = useAtom(submissionsAtom);

  const phlote = usePhlote();

  React.useEffect(() => {
    const getContent = () => {
      phlote.getAllCurations().then((content) => {
        const reversed = ([...content] as ArchiveCuration[]).reverse();
        const cleaned = reversed.map((submission) =>
          cleanSubmission(submission)
        );
        setSubmissions(cleaned);
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

//TODO: remove this, is just bandaid
const cleanSubmission = (submission: ArchiveCuration) => {
  const cleaned = { ...submission };
  if (submission.mediaURI.includes("opensea")) {
    cleaned.marketplace = "OpenSea";
  }
  if (submission.mediaURI.includes("catalog")) {
    cleaned.marketplace = "Catalog";
  }
  if (submission.mediaURI.includes("zora")) {
    cleaned.marketplace = "Zora";
  }
  if (submission.mediaURI.includes("foundation")) {
    cleaned.marketplace = "Foundation";
  }

  return cleaned;
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
