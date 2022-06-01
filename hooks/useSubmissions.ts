import { atom, useAtom } from "jotai";
import { useInfiniteQuery, useQuery } from "react-query";
import { useSearchTerm } from "../components/SearchBar";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetSubmissionsDocument,
  GetSubmissionsQuery,
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
export const useSubmissionSearch = () => {
  const apolloClient = initializeApollo();
  const [searchTerm] = useSearchTerm();
  const [filters] = useSearchFilters();

  const searchResults = useQuery(
    ["submission-search", searchTerm],
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
    ["submissions-search-infinite", filters, searchResults],
    fetchSubmissionsForSearch,
    {
      getNextPageParam: (lastPage, pages) => {
        return lastPage.nextPage;
      },
    }
  );

  // useEffect(() => {
  //   gaEvent({
  //     action: "search",
  //     params: {
  //       search_term: searchTerm,
  //     },
  //   });
  // }, [searchTerm]);

  // const showSearchResults =
  //   (!!searchTerm && searchTerm !== "") || !!Object.keys(filters).length;

  // return showSearchResults ? searchResults.data : null;
};
