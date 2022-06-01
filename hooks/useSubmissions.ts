import { atom, useAtom } from "jotai";
import { useEffect } from "react";
import { useInfiniteQuery, useQuery } from "react-query";
import { useSearchTerm } from "../components/SearchBar";
import { gaEvent } from "../lib/ga";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetSubmissionsDocument,
  GetSubmissionsQuery,
  SubmissionsSearchDocument,
  SubmissionsSearchQuery,
  Submission_Filter,
} from "../lib/graphql/generated";

const searchFiltersAtom = atom<Submission_Filter>({});
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
  }, [searchTerm]);
};

// Test cases:
// no search term or filter p
// search term only
// filter only
// both search term and filter
export const useSubmissionSearch = () => {
  const apolloClient = initializeApollo();
  const [filters] = useSearchFilters();
  const [searchTerm] = useSearchTerm();

  const searchResults = useQuery(
    ["submission-search-ids", searchTerm],
    async () => {
      const searchQuery = await apolloClient.query<SubmissionsSearchQuery>({
        query: SubmissionsSearchDocument,
        variables: { searchTerm: `'${searchTerm}'` },
        fetchPolicy: "network-only",
      });

      return searchQuery.data.submissionsSearch.map(({ id }) => id);
    },
    {
      keepPreviousData: true,
      enabled: !!searchTerm && searchTerm !== "",
    }
  );

  const fetchSubmissionsForSearch = async ({ pageParam = 0 }) => {
    const filter = { ...filters };
    if (searchResults.data) filter.id_in = searchResults.data;

    const res = await apolloClient.query<GetSubmissionsQuery>({
      query: GetSubmissionsDocument,
      variables: { filter, skip: pageParam },
      fetchPolicy: "network-only",
    });

    return {
      submissions: res.data.submissions,
      nextPage: res.data.submissions.length
        ? pageParam + res.data.submissions.length
        : undefined,
    };
  };

  return useInfiniteQuery(
    ["submissions-search", filters, searchResults],
    fetchSubmissionsForSearch,
    {
      getNextPageParam: (lastPage, pages) => {
        return lastPage.nextPage;
      },
    }
  );
};
