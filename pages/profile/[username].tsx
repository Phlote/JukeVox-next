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
import { supabase } from "../../lib/supabase";
import {
  getProfileForWallet,
  getSubmissionsWithFilter,
} from "../../utils/supabase";

export default function Profile(props) {
  const router = useRouter();
  const { submissions, profile } = props;

  if (router.isFallback) {
    //TODO better loading
    return <div>Loading...</div>;
  }

  return (
    <ArchiveLayout>
      <div className="flex flex-col">
        <div className="flex">
          <div className="flex-grow"></div> <UserStatsBar profile={profile} />
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
  const { username } = params;

  const profilesQuery = await supabase
    .from("profiles")
    .select()
    .match({ username });

  if (profilesQuery.error) throw profilesQuery.error;
  // TODO this is a bit redundant, update the profiles table
  const { wallet } = profilesQuery.data[0];

  return {
    props: {
      // TODO: everyone is a curator when it's just their submissions
      submissions: await getSubmissionsWithFilter(null, { username }, true),
      profile: await getProfileForWallet(wallet),
    },
    revalidate: 60,
  };
}

export async function getStaticPaths() {
  const profilesQuery = await supabase.from("profiles").select();

  if (profilesQuery.error) throw profilesQuery.error;

  // move quickly to having sub profiles
  const paths = profilesQuery.data
    .filter(({ username }) => !!username)
    .map(({ username }) => ({
      params: {
        username,
      },
    }));

  return { paths, fallback: true };
}
