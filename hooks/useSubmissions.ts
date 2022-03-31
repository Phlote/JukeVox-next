import FuzzySearch from "fuzzy-search";
import { atom, useAtom } from "jotai";
import { useQuery } from "react-query";
import { ArchiveCuration, Curation } from "../types/curations";
import { supabase } from "../utils/supabase";

export const useSubmissions = () => {
  const getSubmissions = async () => {
    const res = await supabase.from("submissions").select();
    const cleaned = res.data.map((s) => cleanSubmission(s));
    const rev = cleaned.reverse();
    return rev as Curation[];
  };

  const query = useQuery("submissions", getSubmissions);
  return query.data;
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
  if (submission.mediaURI.includes("youtube")) {
    cleaned.marketplace = "Youtube";
  }

  return cleaned;
};

const searchFiltersAtom = atom<Partial<ArchiveCuration>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

const isPartialMatch = (
  curation: ArchiveCuration,
  filters: Partial<ArchiveCuration>
) => {
  return Object.keys(filters).reduce((acc, key) => {
    return acc && filters[key] === curation[key];
  }, true);
};

export const useSubmissionSearch = (searchTerm = "") => {
  const submissions = useSubmissions();
  const [filters] = useSearchFilters();
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
