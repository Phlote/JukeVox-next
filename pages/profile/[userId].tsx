import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import Link from "next/link";
import { useRouter } from "next/router";
import { UserProfile } from "../../components/Forms/ProfileSettingsForm";
import Layout, { ArchiveLayout } from "../../components/Layouts";
import { RatingsMeter } from "../../components/RatingsMeter";
import {
  ArchiveTableDataCell,
  ArchiveTableHeader,
  ArchiveTableRow,
  SubmissionDate,
} from "../../components/Tables/archive";
import { UserStatsBar } from "../../components/UserStatsBar";
import { useIsCurator } from "../../hooks/useIsCurator";
import useENSName from "../../hooks/web3/useENSName";
import { initializeApollo } from "../../lib/graphql/apollo";
import {
  GetAllWalletsDocument,
  GetAllWalletsQuery,
  GetSubmissionsByWalletDocument,
  GetSubmissionsByWalletQuery,
} from "../../lib/graphql/generated";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";
import { getProfileForWallet } from "../../utils/supabase";

export default function Profile(props) {
  const router = useRouter();
  const { submissions, profile } = props;
  const userId = router.query.userId;
  const isCurator = useIsCurator();
  const { account } = useWeb3React();

  const promptToMakeProfile = isCurator && userId === account;

  const ENSName = useENSName(userId as string);

  if (router.isFallback) {
    //TODO better loading
    return <div>Loading...</div>;
  }

  return (
    <ArchiveLayout>
      <div className="flex flex-col">
        <div className="flex justify-center">
          {profile && (
            <>
              <div className="flex-grow"></div>
              <UserStatsBar profile={profile} />
            </>
          )}
          {!profile && (
            <div className="flex flex-col items-center">
              <h1>{`${ENSName || userId}'s Curations`}</h1>
              <div className="h-4" />
              {promptToMakeProfile && (
                <Link href="/editprofile" passHref>
                  <h1 className="italic underline cursor-pointer">
                    {"Click here to set your profile"}
                  </h1>
                </Link>
              )}
            </div>
          )}
        </div>

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
              <ArchiveTableHeader label="Platform" filterKey="marketplace" />
              <ArchiveTableHeader label="Co-Signs" />
            </tr>
          </thead>

          {submissions?.length > 0 && (
            <tbody>
              <tr className="h-4" />
              {submissions?.map((submission: Submission) => {
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
                          className="underline"
                          onClick={(e) => e.stopPropagation()}
                        >
                          {mediaTitle}
                        </a>
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>{marketplace}</ArchiveTableDataCell>

                      <ArchiveTableDataCell>
                        <RatingsMeter
                          initialCosigns={cosigns}
                          submissionId={id}
                          submitterWallet={submitterWallet}
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

Profile.getLayout = function getLayout(page) {
  return (
    <Layout>
      <ArchiveLayout>{page}</ArchiveLayout>
    </Layout>
  );
};

// params will contain the wallet for each generated page.
export async function getStaticProps({ params }) {
  const { userId } = params;
  const apolloClient = initializeApollo();

  const getSubmissionsByWallet = async (wallet: string) => {
    const res = await apolloClient.query<GetSubmissionsByWalletQuery>({
      query: GetSubmissionsByWalletDocument,
      variables: { wallet },
    });

    return res.data.submissions;
  };

  if (ethers.utils.isAddress(userId)) {
    const wallet = userId;

    return {
      props: {
        submissions: await getSubmissionsByWallet(wallet),
      },
      revalidate: 60,
    };
  }

  const username = userId;

  const profilesQuery = await supabase
    .from("profiles")
    .select()
    .match({ username });

  if (profilesQuery.error) throw profilesQuery.error;
  const { wallet } = profilesQuery.data[0];

  return {
    props: {
      // TODO: everyone is a curator when it's just their submissions
      submissions: await getSubmissionsByWallet(wallet),
      profile: await getProfileForWallet(wallet),
    },
    revalidate: 60,
  };
}

export async function getStaticPaths() {
  const apolloClient = initializeApollo();
  const res = await apolloClient.query<GetAllWalletsQuery>({
    query: GetAllWalletsDocument,
  });

  // if we have a username for this wallet, the page should use this instead of the wallet
  const userIds = await Promise.all(
    res.data.submissions.map(async ({ submitterWallet }) => {
      const profilesQuery = await supabase
        .from("profiles")
        .select()
        .match({ wallet: submitterWallet });

      if (profilesQuery.error) console.error(profilesQuery.error);
      if (profilesQuery.data[0] && profilesQuery.data[0].username)
        return (profilesQuery.data[0] as UserProfile).username;

      return submitterWallet;
    })
  );

  // can be wallet or username
  const paths = userIds.map((userId: string) => ({
    params: {
      userId,
    },
  }));

  return { paths, fallback: true };
}
