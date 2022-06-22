// import throttle from "lodash.throttle";
import { useRouter } from "next/router";
import React, { useEffect } from "react";
import Layout, { ArchiveLayout } from "../components/Layouts";
import { RatingsMeter } from "../components/RatingsMeter";
import { useSearchTerm } from "../components/SearchBar";
import {
  ArchiveTableDataCell,
  ArchiveTableHeader,
  ArchiveTableRow,
  SubmissionDate,
} from "../components/Tables/archive";
import { Username } from "../components/Username";
import { useOnScrollToBottom } from "../hooks/useOnScrollToBottom";
import {
  useSearchFilters,
  useSubmissionSearch,
  useTrackSearchQueries,
} from "../hooks/useSubmissions";
import { Submission } from "../types";

function Archive({ query }) {
  const [searchBarContent, setSearchBar] = useSearchTerm();
  const [selectedFilters, setFilters] = useSearchFilters();

  const router = useRouter();
  // set state variables on initial render
  useEffect(() => {
    if (query) {
      const { search, filters } = router.query;

      if (search) {
        setSearchBar(decodeURI(search as string));
      }
      if (filters) {
        setFilters(JSON.parse(decodeURI(filters as string)));
      }
    }

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query]);

  const updateQueryParams = React.useCallback(
    async (router, searchTerm: string, filters: Partial<Submission>) => {
      await router.push(
        {
          pathname: "/archive",
          query: {
            search: searchTerm ? encodeURI(searchTerm) : undefined,
            filters: filters ? encodeURI(JSON.stringify(filters)) : undefined,
          },
        },
        undefined,
        { shallow: true }
      );
    },
    []
  );

  useEffect(() => {
    if (router) updateQueryParams(router, searchBarContent, selectedFilters);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchBarContent, selectedFilters]);

  const submissions = useSubmissionSearch();
  const noResults =
    !submissions.isLoading &&
    !submissions.isFetching &&
    submissions.data?.pages[0].submissions.length === 0;

  useTrackSearchQueries();

  const scrollRef = useOnScrollToBottom(
    submissions.fetchNextPage,
    submissions.hasNextPage,
    1000
  );

  return (
    <div ref={scrollRef} className="flex flex-col h-full overflow-y-scroll">
      <table className="table-fixed w-full text-center mt-8 ">
        <thead
          style={{
            borderBottom: "1px solid white",
            paddingBottom: "1rem",
          }}
        >
          <tr>
            <ArchiveTableHeader label="Date" />
            <ArchiveTableHeader label="Artist" />
            <ArchiveTableHeader label="Title" />
            <ArchiveTableHeader label="Media Type" filterKey="mediaType" />
            <ArchiveTableHeader label="Platform" filterKey="marketplace" />
            <ArchiveTableHeader label="Curator" filterKey="curatorWallet" />
            <ArchiveTableHeader label="Co-Signs" />
          </tr>
        </thead>

        <tbody>
          <tr className="h-4" />
          {submissions?.data?.pages.map((group, i) => (
            <React.Fragment key={i}>
              {group?.submissions?.map((submission) => {
                const {
                  id,
                  submissionTime,
                  curatorWallet,
                  artistName,
                  mediaTitle,
                  mediaType,
                  mediaURI,
                  marketplace,
                  cosigns,
                  username,
                } = submission;

                return (
                  <React.Fragment key={id}>
                    <ArchiveTableRow
                      className="hover:opacity-80 cursor-pointer"
                      onClick={() => {
                        router.push(`/submission/${id}`);
                      }}
                    >
                      <ArchiveTableDataCell>
                        <SubmissionDate submissionTimestamp={submissionTime} />
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{artistName}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <a
                          rel="noreferrer"
                          target="_blank"
                          href={mediaURI}
                          className="hover:opacity-50"
                          onClick={(e) => e.stopPropagation()}
                        >
                          {mediaTitle}
                        </a>
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>{marketplace}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <Username
                          username={username}
                          wallet={curatorWallet}
                          linkToProfile
                        />
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <RatingsMeter
                          submissionId={id}
                          submitterWallet={curatorWallet}
                          initialCosigns={cosigns}
                        />
                      </ArchiveTableDataCell>
                    </ArchiveTableRow>
                    <tr className="h-4" />
                  </React.Fragment>
                );
              })}
            </React.Fragment>
          ))}
          {!submissions.hasNextPage && <tr className="h-32 "></tr>}
        </tbody>
      </table>
      {submissions.isFetching && (
        <div className="w-full h-full flex-grow flex justify-center items-center">
          <p className="text-lg italic text-white">{"Fetching..."}</p>
        </div>
      )}
      {noResults && (
        <div
          className="w-full h-full flex-grow flex justify-center items-center"
          style={{ color: "rgba(105, 105, 105, 1)" }}
        >
          <p className="text-lg italic">{"No Search Results"}</p>
        </div>
      )}
    </div>
  );
}

Archive.getLayout = function getLayout(page) {
  return (
    <Layout>
      <ArchiveLayout>{page}</ArchiveLayout>
    </Layout>
  );
};

Archive.getInitialProps = async ({ query }) => {
  return { query };
};

export default Archive;
