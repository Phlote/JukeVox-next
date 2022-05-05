import { useRouter } from "next/router";
import { useEffect, useState } from "react";
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
import { useSubmissionSearch } from "../hooks/useSubmissions";
import { gaEvent } from "../lib/ga";
import { Submission } from "../types";

function Archive(props) {
  // we can do this because the prop is unchanging
  const [searchTerm] = useSearchTerm();
  const searchResults = useSubmissionSearch(searchTerm);
  const [submissions, setSubmissions] = useState<Submission[]>([]);
  const router = useRouter();

  // subject to change based on user's search query
  useEffect(() => {
    if (
      searchResults &&
      JSON.stringify(searchResults) !== JSON.stringify(submissions)
    ) {
      gaEvent({
        action: "search",
        params: {
          search_term: searchTerm,
        },
      });
      setSubmissions(searchResults);
    }
  }, [searchResults, submissions, searchTerm]);

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
            <ArchiveTableHeader label="Curator" filterKey="curatorWallet" />
            <ArchiveTableHeader label="Co-Signs" />
          </tr>
        </thead>

        {submissions.length > 0 && (
          <tbody>
            <tr className="h-4" />
            {submissions?.map((curation) => {
              const {
                id,
                curatorWallet,
                artistName,
                mediaTitle,
                mediaType,
                mediaURI,
                marketplace,
                submissionTime,
                cosigns,
                username,
              } = curation;

              return (
                <>
                  <ArchiveTableRow
                    key={`${submissionTime}`}
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
                </>
              );
            })}
          </tbody>
        )}
      </table>
      {submissions.length === 0 && (
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
//   return {
//     props: {
//       allSubmissions: await getSubmissionsWithFilter(),
//     },
//     revalidate: 60,
//   };
// }

export default Archive;
