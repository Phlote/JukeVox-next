import { atom, useAtom } from "jotai";
import { useEffect } from "react";
import { useInfiniteQuery, useQuery } from "react-query";
import { useSearchTerm } from "../components/SearchBar";
import { gaEvent } from "../lib/ga";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetSubmissionsDocument,
  GetSubmissionsQuery,
  Submission,
  SubmissionArchiveFieldsFragment,
  SubmissionsSearchDocument,
  SubmissionsSearchQuery,
  Submission_Filter,
} from "../lib/graphql/generated";

const searchFiltersAtom = atom<Submission_Filter>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

export const useSubmissions = (
  filter?: Submission_Filter
): SubmissionArchiveFieldsFragment[] => {
  const apolloClient = initializeApollo();

  // can we refetch infinitely until we get the correct number?
  const submissionsQuery = useQuery(["submissions", filter], async () => {
    const res = await apolloClient.query<GetSubmissionsQuery>({
      query: GetSubmissionsDocument,
      variables: { filter },
      fetchPolicy: "network-only",
    });
    return res.data.submissions;
  });

  return submissionsQuery.data;
};

export const useSubmissionsInfiniteQuery = (filter?: Submission_Filter) => {
  const apolloClient = initializeApollo();
  const fetchSubmissions = async ({ pageParam = 0 }) => {
    console.log("page param: ", pageParam);
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
  // can we refetch infinitely until we get the correct number?
  return useInfiniteQuery(["submissions-infinite", filter], fetchSubmissions, {
    getNextPageParam: (lastPage, pages) => {
      return lastPage.nextPage;
    },
  });
};

// Test cases:
// no search term or filter p
// search term only
// filter only
// both search term and filter
export const useSubmissionSearch = (): Submission[] => {
  const apolloClient = initializeApollo();
  const [searchTerm] = useSearchTerm();
  const [filters] = useSearchFilters();

  const searchResults = useQuery(
    ["submission-search", searchTerm, filters],
    async () => {
      let IDs = [];
      if (searchTerm) {
        const searchQuery = await apolloClient.query<SubmissionsSearchQuery>({
          query: SubmissionsSearchDocument,
          variables: { searchTerm: `'${searchTerm}'` },
        });

        IDs = searchQuery.data.submissionsSearch.map(({ id }) => id);
      }

      const filter = { ...filters };
      if (!!IDs.length) filter.id_in = IDs;

      const filterQuery = await apolloClient.query<GetSubmissionsQuery>({
        query: GetSubmissionsDocument,
        variables: { filter },
      });

      return filterQuery.data.submissions;
    },

    {
      keepPreviousData: true,
      enabled:
        (!!searchTerm && searchTerm !== "") || !!Object.keys(filters).length,
    }
  );

  useEffect(() => {
    gaEvent({
      action: "search",
      params: {
        search_term: searchTerm,
      },
    });
  }, [searchTerm]);

  const showSearchResults =
    (!!searchTerm && searchTerm !== "") || !!Object.keys(filters).length;

  return showSearchResults ? searchResults.data : null;
};
