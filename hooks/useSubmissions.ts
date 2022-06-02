import { atom, useAtom } from "jotai";
import { useQuery } from "react-query";
import { searchSubmissions } from "../controllers/search";
import { getSubmissions } from "../controllers/submissions";
import { Submission } from "../types";
import { asyncDebounce } from "../utils";
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

  const { data } = useQuery(
    ["search", searchTerm, filters, isCuratorQuery?.data?.isCurator],
    asyncDebounce(
      async () =>
        await searchSubmissions(
          searchTerm,
          filters,
          isCuratorQuery?.data?.isCurator
        ),
      500
    ),
    { keepPreviousData: true, enabled: isCuratorQuery?.isSuccess }
  );

  return (data ?? []) as Submission[];
};
