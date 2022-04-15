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

function Archive() {
  const [searchTerm] = useSearchTerm();
  const curations = useSubmissionSearch(searchTerm);

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

          {curations.length > 0 && (
            <tbody>
              <tr className="h-4" />
              {curations?.map((curation) => {
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
                        <Username submission={curation} linkToProfile />
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
        {curations.length === 0 && (
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

export default Archive;
