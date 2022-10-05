import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import Link from "next/link";
import { useRouter } from "next/router";
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
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";
import {
  getProfileForWallet,
  getSubmissionsWithFilter,
} from "../../utils/supabase";
import { useProfile } from "../../components/Forms/ProfileSettingsForm";
import { useMoralis } from "react-moralis";

export default function Profile(props) {
  const router = useRouter();
  const { submissions } = props;
  const uuid = router.query.uuid;
  const isCurator = useIsCurator();
  const { account } = useMoralis();

  const promptToMakeProfile = isCurator && uuid === account;

  const ENSName = useENSName(uuid as string);
  const profile = useProfile(uuid);

  if (router.isFallback) {
    //TODO better loading
    return <div>Loading...</div>;
  }

  return (
    <div className="flex flex-col ">
      <div className="flex justify-center">
        {profile?.data ? (
            <>
              <div className="flex-grow"></div>
              <UserStatsBar profile={profile.data} />
            </>
          ) :
          profile?.status === "loading" ? <div>Loading...</div> : (
            <div className="flex flex-col items-center">
              <h1>{`${ENSName || uuid}'s Curations`}</h1>
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
            {submissions?.map((submission) => {
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
              } = submission;

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
                        submitterWallet={curatorWallet}
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
  const { uuid } = params;

  if (ethers.utils.isAddress(uuid)) {
    return {
      props: {
        submissions: await getSubmissionsWithFilter(null, {
          curatorWallet: uuid,
        }),
      },
      revalidate: 60,
    };
  }

  const username = uuid;

  const profilesQuery = await supabase
    .from("profiles")
    .select()
    .match({ username });

  if (profilesQuery.error) throw profilesQuery.error;
  //TODO: this is a bit dumb, we should have more general querying for profiles
  const { wallet } = profilesQuery.data[0];

  return {
    props: {
      submissions: await getSubmissionsWithFilter(null, { username }),
      profile: await getProfileForWallet(wallet),
    },
    revalidate: 60,
  };
}

export async function getStaticPaths() {
  const submissionsQuery = await supabase.from("submissions").select();

  if (submissionsQuery.error) throw submissionsQuery.error;

  // IDEA: should we have two pages for each user?
  const UUIDs = submissionsQuery.data.map((submission: Submission) => {
    return submission.curatorWallet;
  });

  // can be wallet or username
  const paths = UUIDs.map((uuid) => ({
    params: {
      uuid,
    },
  }));

  return { paths, fallback: true };
}
