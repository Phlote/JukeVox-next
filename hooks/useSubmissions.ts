import { atom, useAtom } from "jotai";
import { useQuery } from "react-query";
import { searchSubmissions } from "../controllers/search";
import { supabase } from "../lib/supabase";
import { Curation } from "../types/curations";

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
const cleanSubmission = (submission: Curation) => {
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
  if (submission.mediaURI.includes("youtu")) {
    cleaned.marketplace = "Youtube";
  }

  return cleaned;
};

const searchFiltersAtom = atom<Partial<Curation>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

export const useSubmissionSearch = (searchTerm = "") => {
  const [filters] = useSearchFilters();
  const { data, isLoading } = useQuery(
    [searchTerm, filters.toString(), "search"],
    async () => searchSubmissions(searchTerm, filters)
  );

  return data ?? [];
};
