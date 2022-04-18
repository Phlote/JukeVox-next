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
import { Curation } from "../types/curations";
import { getSubmissionsWithFilter } from "../utils/supabase";

function Archive(props) {
  const { allSubmissions } = props;
  // we can do this because the prop is unchanging
  const [submissions, setSubmissions] = useState<Curation[]>(allSubmissions);
  const [searchTerm] = useSearchTerm();
  const searchResults = useSubmissionSearch(searchTerm);

  // subject to change based on user's search query
  useEffect(() => {
    if (!searchTerm || searchTerm === "") setSubmissions(allSubmissions);
    else if (
      searchTerm &&
      searchTerm !== "" &&
      searchResults &&
      searchResults !== submissions
    )
      setSubmissions(searchResults);
  }, [searchResults, submissions, searchTerm, allSubmissions]);

  return (
    <ArchiveLayout>
      <div className="flex flex-col">
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
                    <ArchiveTableRow key={`${submissionTime}`}>
                      <ArchiveTableDataCell>
                        <SubmissionDate submissionTimestamp={submissionTime} />
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{artistName}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <a
                          rel="noreferrer"
                          target="_blank"
                          href={mediaURI}
                          className="underline"
                        >
                          {mediaTitle}
                        </a>
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>{marketplace}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <Username username={username} linkToProfile />
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
            className="w-full mt-4 flex-grow flex justify-center items-center"
            style={{ color: "rgba(105, 105, 105, 1)" }}
          >
            <p className="text-lg italic">{"No Search Results"}</p>
          </div>
        )}
      </div>
    </ArchiveLayout>
  );
}

Archive.getLayout = function getLayout(page) {
  return (
    <Layout>
      <ArchiveLayout>{page}</ArchiveLayout>
    </Layout>
  );
};

export async function getStaticProps({ params }) {
  return {
    props: {
      allSubmissions: await getSubmissionsWithFilter(),
    },
    revalidate: 60,
  };
}

export default Archive;
