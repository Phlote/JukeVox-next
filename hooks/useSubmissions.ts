import { atom, useAtom } from "jotai";
import { useCallback, useEffect } from "react";
import { useInfiniteQuery, useQuery } from "react-query";
import { useSearchTerm } from "../components/SearchBar";
import { searchSubmissions } from "../controllers/search";
import { getSubmissions } from "../controllers/submissions";
import { gaEvent } from "../lib/ga";
import { ArtistSubmission, CuratorSubmission } from "../types";

export const useSubmissions = (
  filters: Partial<ArtistSubmission | CuratorSubmission> = {},
  wallet: string = undefined
) => {
  const { data } = useQuery(
    ["submissions", filters, wallet],
    async () => getSubmissions(filters),
    { keepPreviousData: true }
  );
  return data ?? [];
};

const searchFiltersAtom = atom<Partial<ArtistSubmission | CuratorSubmission>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

export const useTrackSearchQueries = () => {
  const [searchTerm] = useSearchTerm();

  useEffect(() => {
    gaEvent({
      action: "search",
      params: {
        search_term: searchTerm,
      },
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchTerm]);
};

export const useSubmissionSearch = () => {
  const [filters] = useSearchFilters();
  const [searchTerm] = useSearchTerm();

  const fetchSubmissions = useCallback(
    async ({ pageParam = 0 }) => {
      return await searchSubmissions(searchTerm, filters, pageParam);
    },
    [searchTerm, filters]
  );

  return useInfiniteQuery(
    ["submissions-search", filters, searchTerm],
    fetchSubmissions,
    {
      getNextPageParam: (lastPage, pages) => {
        return lastPage.nextPage;
      },
      refetchOnWindowFocus: false,
      keepPreviousData: true,
    }
  );
};
