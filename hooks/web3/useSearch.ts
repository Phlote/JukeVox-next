import { atom, useAtom } from "jotai";
import React from "react";
import { useQuery } from "react-query";
import { ArchiveCuration } from "../../types/curations";
import { nextApiRequest } from "../../utils";
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
  if (submission.mediaURI.includes("spotify")) {
    cleaned.marketplace = "Spotify";
  }
  if (submission.mediaURI.includes("soundcloud")) {
    cleaned.marketplace = "Soundcloud";
  }

  return cleaned;
};

const searchFiltersAtom = atom<Partial<ArchiveCuration>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

const searchResultsAtom = atom<ArchiveCuration[]>([]);

export const useSearch = (searchTerm = "") => {
  const [filters] = useSearchFilters();
  const [searchResults, setSearchResults] = useAtom(searchResultsAtom);

  const query = async () => {
    if (searchTerm === "") return [];
    const res = await nextApiRequest(
      `elastic/search-documents?searchTerm=${searchTerm}`,
      "POST",
      { searchTerm, filters }
    );
    return res.results;
  };

  const elasticSearchQuery = useQuery([searchTerm, "search"], query);

  React.useEffect(() => {
    console.log(elasticSearchQuery.data);
    if (elasticSearchQuery.data) {
      const pending = searchResults.filter(
        (result) => result.transactionPending
      );
      setSearchResults([...pending, ...elasticSearchQuery.data]);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [elasticSearchQuery.data]);

  return { searchResults, setSearchResults };
};
