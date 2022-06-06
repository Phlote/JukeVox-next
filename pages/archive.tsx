import { useRouter } from "next/router";
import React from "react";
import Layout, { ArchiveLayout } from "../components/Layouts";
import { RatingsMeter } from "../components/RatingsMeter";
import {
  ArchiveTableDataCell,
  ArchiveTableHeader,
  ArchiveTableRow,
  SubmissionDate,
} from "../components/Tables/archive";
import { Username } from "../components/Username";
import { useOnScrollToBottom } from "../hooks/useOnScrollToBottom";
import {
  useSubmissionSearch,
  useTrackSearchQueries,
} from "../hooks/useSubmissions";

function Archive(props) {
  const router = useRouter();

  const submissions = useSubmissionSearch();
  const noResults =
    !submissions.isLoading &&
    submissions.data?.pages[0].submissions.length === 0;

  useTrackSearchQueries();

  console.log("has next: ", submissions.hasNextPage);
  const scrollRef = useOnScrollToBottom(
    submissions.fetchNextPage,
    false
    // 1000
  );

  return (
    <div ref={scrollRef} className="flex flex-col h-full overflow-y-scroll">
      <table className="table-fixed w-full text-center mt-8 ">
        <thead
          className="sticky top-0 z-10 bg-black"
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
        </tbody>
      </table>
      {submissions.isFetching && (
        <div
          className="w-full flex-grow flex justify-center"
          style={{ color: "white" }}
        >
          <p className="text-lg italic mt-4 mb-8">{"Fetching..."}</p>
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

export default Archive;
