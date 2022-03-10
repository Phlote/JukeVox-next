import { useRouter } from "next/router";
import { ShortenedWallet } from "../components/Account";
import { ArchiveLayout } from "../components/Layouts";
import { RatingsMeter } from "../components/RatingsMeter";
import {
  ArchiveTableHeader,
  ArchiveTableRow,
  ArchiveTableDataCell,
  SubmissionDate,
} from "../components/Tables/archive";
import { useAllSubmissions } from "../hooks/web3/useNFTSearch";

const MyArchive = (props) => {
  const router = useRouter();
  const { wallet } = router.query;
  const { submissions } = useAllSubmissions();
  const mySubmissions = submissions.filter(
    (submission) => submission.curatorWallet === wallet
  );

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
              <ArchiveTableHeader label="Media Type" filterKey={"mediaType"} />
              <ArchiveTableHeader label="Marketplace" filterKey="marketplace" />
              <ArchiveTableHeader label="Rating" />
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
                  transactionPending,
                  submissionTime,
                } = curation;

                return (
                  <>
                    <ArchiveTableRow
                      style={transactionPending ? { opacity: 0.5 } : undefined}
                      key={`${submissionTime}`}
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
                          className="underline"
                        >
                          {mediaTitle}
                        </a>
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>{marketplace}</ArchiveTableDataCell>

                      <ArchiveTableDataCell>
                        <RatingsMeter
                          editionId={id}
                          txnPending={transactionPending}
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
};

export default MyArchive;