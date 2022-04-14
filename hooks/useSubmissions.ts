import { atom, useAtom } from "jotai";
import { useQuery } from "react-query";
import { searchSubmissions } from "../controllers/search";
import { getSubmissions } from "../controllers/submissions";
import { Curation } from "../types/curations";

export const useSubmissions = (filters: Partial<Curation> = {}) => {
  const query = useQuery(["submissions", JSON.stringify(filters)], async () => {
    return await getSubmissions(filters);
  });
  return query.data;
};

//TODO: remove this, is just bandaid

const searchFiltersAtom = atom<Partial<Curation>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

export const useSubmissionSearch = (searchTerm = "") => {
  const [filters] = useSearchFilters();
  const { data, isLoading } = useQuery(
    [searchTerm, filters, "search"],
    async () => searchSubmissions(searchTerm, filters),
    { keepPreviousData: true }
  );

  return data ?? [];
};
