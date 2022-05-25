import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import { useRouter } from "next/router";
import { useEffect } from "react";
import { useQuery } from "react-query";
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
import { useSearchFilters } from "../hooks/useSubmissions";
import { gaEvent } from "../lib/ga";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetSubmissionsDocument,
  GetSubmissionsQuery,
  SubmissionsSearchDocument,
  SubmissionsSearchQuery,
} from "../lib/graphql/generated";

// Test cases:
// no search term or filter p
// search term only
// filter only
// both search term and filter
const useSubmissionSearch = () => {
  const apolloClient = initializeApollo();
  const [searchTerm] = useSearchTerm();
  const [filters] = useSearchFilters();

  const searchResults = useQuery(
    ["submission-search", searchTerm, filters],
    async () => {
      let IDs = [];
      if (searchTerm) {
        const searchQuery = await apolloClient.query<SubmissionsSearchQuery>({
          query: SubmissionsSearchDocument,
          variables: { searchTerm: searchTerm + ":*" },
        });

        IDs = searchQuery.data.submissionsSearch.map(({ id }) => id);
      }

      const filter = { ...filters };
      if (!!IDs.length) filter.id_in = IDs;

      const filterQuery = await apolloClient.query<GetSubmissionsQuery>({
        query: GetSubmissionsDocument,
        variables: { filter },
      });

      return filterQuery.data.submissions;
    },

    {
      keepPreviousData: true,
      enabled:
        (!!searchTerm && searchTerm !== "") || !!Object.keys(filters).length,
    }
  );

  useEffect(() => {
    gaEvent({
      action: "search",
      params: {
        search_term: searchTerm,
      },
    });
  }, [searchTerm]);

  const showSearchResults =
    (!!searchTerm && searchTerm !== "") || !!Object.keys(filters).length;

  return showSearchResults ? searchResults.data : null;
};

function Archive(props) {
  const { allSubmissions } = props;

  const { library } = useWeb3React<Web3Provider>();

  const router = useRouter();

  const searchResults = useSubmissionSearch();

  const submissions = searchResults ? searchResults : allSubmissions;

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
                        wallet={ethers.utils.hexlify(submitterWallet)}
                        linkToProfile
                      />
                    </ArchiveTableDataCell>
                    <ArchiveTableDataCell>
                      <RatingsMeter
                        submissionAddress={id}
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
  const res = await apolloClient.query<GetSubmissionsQuery>({
    query: GetSubmissionsDocument,
  });
  return {
    props: {
      allSubmissions: res.data.submissions,
    },

    revalidate: 60,
  };
}

export default Archive;
