import { atom, useAtom } from "jotai";
import { useQuery } from "react-query";
import { searchSubmissions } from "../controllers/search";
import { getSubmissions } from "../controllers/submissions";
import { Curation } from "../types/curations";

export const useSubmissions = (
  filters: Partial<Curation> = {},
  wallet: string = undefined
) => {
  const { data } = useQuery(
    ["submissions", filters, wallet],
    async () => getSubmissions(filters, wallet),
    { keepPreviousData: true }
  );
  return data ?? [];
};

const searchFiltersAtom = atom<Partial<Curation>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

export const useSubmissionSearch = (searchTerm = "") => {
  const [filters] = useSearchFilters();
  const { data } = useQuery(
    ["search", searchTerm, filters],
    async () => searchSubmissions(searchTerm, filters),
    { keepPreviousData: true }
  );

  return data ?? [];
};
