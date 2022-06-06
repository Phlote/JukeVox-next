import { atom, useAtom } from "jotai";
import { useQuery } from "react-query";
import { searchSubmissions } from "../controllers/search";
import { getSubmissions } from "../controllers/submissions";
import { Submission } from "../types";
import { useIsCurator } from "./useIsCurator";

export const useSubmissions = (
  filters: Partial<Submission> = {},
  wallet: string = undefined
) => {
  const { data } = useQuery(
    ["submissions", filters, wallet],
    async () => getSubmissions(filters),
    { keepPreviousData: true }
  );
  return data ?? [];
};

const searchFiltersAtom = atom<Partial<Submission>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

export const useSubmissionSearch = (searchTerm = "") => {
  const [filters] = useSearchFilters();
  const isCuratorQuery = useIsCurator();

  return useQuery(
    ["search", searchTerm, filters, isCuratorQuery?.data?.isCurator],
    async () => await searchSubmissions(searchTerm, filters),

    { keepPreviousData: true, enabled: isCuratorQuery?.isSuccess }
  );
};
