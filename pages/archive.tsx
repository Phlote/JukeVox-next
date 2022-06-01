import { ethers } from "ethers";
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
import {
  useSubmissionSearch,
  useTrackSearchQueries,
} from "../hooks/useSubmissions";

function Archive(props) {
  const submissions = useSubmissionSearch();
  const noResults =
    submissions.data?.pages[0].submissions.length === 0 &&
    !submissions.isLoading;
  useTrackSearchQueries();
  const router = useRouter();

  return (
    <div className="flex flex-col h-full">
      <table className="table-fixed w-full text-center mt-8">
        <thead>
          <tr
            style={{
              borderBottom: "1px solid white",
              paddingBottom: "1rem",
            }}
          >
            <ArchiveTableHeader label="Date" />
            <ArchiveTableHeader label="Artist" />
            <ArchiveTableHeader label="Title" />
            <ArchiveTableHeader label="Media Type" filterKey="mediaType" />
            <ArchiveTableHeader label="Platform" filterKey="marketplace" />
            <ArchiveTableHeader label="Curator" filterKey="submitterWallet" />
            <ArchiveTableHeader label="Co-Signs" />
          </tr>
        </thead>

        {submissions.data?.pages.length > 0 && (
          <tbody>
            <tr className="h-4" />
            {submissions?.data?.pages.map((group, i) => (
              <React.Fragment key={i}>
                {group.submissions.map((submission) => {
                  const {
                    id,
                    timestamp,
                    submitterWallet,
                    artistName,
                    mediaTitle,
                    mediaType,
                    mediaURI,
                    marketplace,
                    cosigns,
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
                          <SubmissionDate submissionTimestamp={timestamp} />
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          {artistName}
                        </ArchiveTableDataCell>
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
                        <ArchiveTableDataCell>
                          {marketplace}
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          <Username
                            wallet={ethers.utils.hexlify(submitterWallet)}
                            linkToProfile
                          />
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          <RatingsMeter
                            submissionAddress={id}
                            submitterWallet={ethers.utils.hexlify(
                              submitterWallet
                            )}
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
        )}
      </table>
      <button className="py-8" onClick={() => submissions.fetchNextPage()}>
        {submissions.isFetchingNextPage
          ? "Loading more..."
          : submissions.hasNextPage
          ? "Load More"
          : "Nothing more to load"}
      </button>
      {noResults && (
        <div
          className="w-full h-full mt-4 flex-grow flex justify-center items-center"
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

// export async function getStaticProps({ params }) {
//   const apolloClient = initializeApollo();
//   const res = await apolloClient.query<GetSubmissionsQuery>({
//     query: GetSubmissionsDocument,
//   });
//   return {
//     props: {
//       initialSubmissions: res.data.submissions,
//     },

//     revalidate: 60,
//   };
// }

export default Archive;
