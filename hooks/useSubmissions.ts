import { atom, useAtom } from "jotai";
import { useQuery } from "react-query";
import { searchSubmissions } from "../controllers/search";
import { getSubmissions } from "../controllers/submissions";
import { Curation } from "../types/curations";
import { useIsCurator } from "./useIsCurator";

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
  const isCurator = useIsCurator();

  const { data } = useQuery(
    ["search", searchTerm, filters, isCurator],
    async () =>
      searchSubmissions(searchTerm, filters, isCurator.data.isCurator),
    { keepPreviousData: true, enabled: isCurator.isSuccess }
  );

  return data ?? [];
};
