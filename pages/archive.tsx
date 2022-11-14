import { useRouter } from "next/router";
import React, { useEffect } from "react";
import { CommentBubble } from "../components/Comments/CommentBubble";
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
import { CommentsContextProvider } from "../hooks/useComments";
import { useOnScrollToBottomWindow } from "../hooks/useOnScrollToBottomWindow";
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
      const { search, filters } = query;

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
            search: searchTerm ? searchTerm : undefined,
            filters: filters ? JSON.stringify(filters) : undefined,
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
  console.log(submissions);
  const noResults =
    !submissions.isLoading &&
    !submissions.isFetching &&
    submissions.data?.pages[0].submissions.length === 0;

  useTrackSearchQueries();

  useOnScrollToBottomWindow(submissions.fetchNextPage, submissions.hasNextPage);

  return (
    <div className="flex flex-col h-full">
          {/* {console.log(submissions.data.pages[0].submissions[0])} */}
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
            {/*// TODO: CURATOR/ARTIST SEPARATION*/}
            <ArchiveTableHeader label="Type" filterKey="isArtist" />
            <ArchiveTableHeader label="Curator" filterKey="submitterWallet" />
            <ArchiveTableHeader label="Co-Signs" filterKey="noOfCosigns" />
          </tr>
        </thead>

        <tbody>
          <tr className="h-4" />
          {submissions?.data?.pages.map((group, i) => (
            <React.Fragment key={i}>
              {group?.submissions?.map((submission) => (
                <ArchiveEntry key={submission.submissionID} submission={submission} />
              ))}
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

const ArchiveEntry: React.FC<{ submission: Submission }> = ({ submission }) => {
  const {
    submissionID,
    submissionTime,
    submitterWallet,
    artistName,
    mediaTitle,
    hotdropAddress,
    isArtist,
    mediaURI,
    cosigns,
    username,
  } = submission;
  const router = useRouter();

  return (
    <CommentsContextProvider threadId={submission.submissionID}>
      <React.Fragment key={submissionID}>
        <ArchiveTableRow
          className="hover:opacity-80 cursor-pointer"
          onClick={() => {
            router.push(`/submission/${submissionID}`);
          }}
        >
          <ArchiveTableDataCell>
            <div className="relative">
              <div className="absolute ml-3">
                <CommentBubble />
              </div>
              <SubmissionDate submissionTimestamp={submissionTime} />
            </div>
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
          {/*    // TODO: CURATOR/ARTIST SEPARATION*/}
          <ArchiveTableDataCell>{isArtist ? 'Artist' : 'Curator'}</ArchiveTableDataCell>
          <ArchiveTableDataCell>
            <Username
              username={username}
              wallet={submitterWallet}
              linkToProfile
            />
          </ArchiveTableDataCell>
          <ArchiveTableDataCell>
            {/* TODO: improve props declaration destructure */}
            <RatingsMeter hotdropAddress={hotdropAddress} submissionID={submissionID} submitterWallet={submitterWallet} initialCosigns={cosigns} isArtist={isArtist}/>
          </ArchiveTableDataCell>
        </ArchiveTableRow>
        <tr className="h-4" />
      </React.Fragment>
    </CommentsContextProvider>
  );
};

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
