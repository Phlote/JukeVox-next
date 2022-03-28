import FuzzySearch from "fuzzy-search";
import { atom, useAtom } from "jotai";
import { ArchiveCuration } from "../../types/curations";

export const useSubmissions = () => {
  const getSubmissions = async () => {};
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

export const useSubmissionSearch = (searchTerm = "") => {
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
