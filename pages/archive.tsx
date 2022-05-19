import { useQuery } from "@apollo/client";
import { ethers } from "ethers";
import { useRouter } from "next/router";
import { useEffect } from "react";
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
import { gaEvent } from "../lib/ga";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetAllSubmissionsDocument,
  GetAllSubmissionsQuery,
  SubmissionsSearchDocument,
} from "../lib/graphql/generated";

const useSearchResults = (searchTerm) => {
  const searchQuery = useQuery(SubmissionsSearchDocument, {
    variables: { searchTerm: searchTerm + ":*" },
    skip: !searchTerm || searchTerm === "",
  });

  return searchQuery?.data?.submissionsSearch;
};

function Archive(props) {
  const { allSubmissions } = props;
  const [searchTerm] = useSearchTerm();

  const router = useRouter();

  useEffect(() => {
    gaEvent({
      action: "search",
      params: {
        search_term: searchTerm,
      },
    });
  }, [searchTerm]);

  const searchResults = useSearchResults(searchTerm);

  const submissions =
    !searchTerm || searchTerm === "" ? allSubmissions : searchResults;

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

        {submissions?.length > 0 && (
          <tbody>
            <tr className="h-4" />
            {submissions?.map((curation) => {
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
              } = curation;

              return (
                <>
                  <ArchiveTableRow
                    key={`${timestamp}`}
                    className="hover:opacity-80 cursor-pointer"
                    onClick={() => {
                      router.push(`/submission/${id}`);
                    }}
                  >
                    <ArchiveTableDataCell>
                      <SubmissionDate submissionTimestamp={timestamp} />
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
                        // username={username}
                        wallet={ethers.utils.hexlify(submitterWallet)}
                        linkToProfile
                      />
                    </ArchiveTableDataCell>
                    <ArchiveTableDataCell>
                      <RatingsMeter
                        submissionId={id}
                        submitterWallet={ethers.utils.hexlify(submitterWallet)}
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
      {submissions?.length === 0 && (
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

export async function getStaticProps({ params }) {
  const apolloClient = initializeApollo();
  const res = await apolloClient.query<GetAllSubmissionsQuery>({
    query: GetAllSubmissionsDocument,
  });
  return {
    props: {
      allSubmissions: res.data.submissions,
    },

    revalidate: 60,
  };
}

export default Archive;
