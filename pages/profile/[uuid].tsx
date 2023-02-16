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
import { GenericSubmission } from "../../types";
import {
  getProfileForWallet,
  getSubmissionsWithFilter,
} from "../../utils/supabase";
import { useProfile } from "../../components/Forms/ProfileSettingsForm";
import { useMoralis } from "react-moralis";
import React, { useState } from "react";

export default function Profile({ cosignedSubmissions, submissions }) {
  const [userListToggle, setUserListToggle] = useState(false)
  const router = useRouter();
  const uuid = router.query.uuid;
  const isCurator = useIsCurator();
  const { account } = useMoralis(); // Moralis account is lowercase !!!!

  const promptToMakeProfile = isCurator && uuid === account;

  // const ENSName = useENSName(uuid as string);
  const profile = useProfile(uuid);

  if (router.isFallback) {
    //TODO better loading
    return <div>Loading...</div>;
  }

  return (
    <div className="flex flex-col ">
      <div className="flex justify-center">
        {profile?.data?.username ? (
            <>
              <div className="flex-grow"></div>
              <label className="relative flex justify-between items-center group p-2 text-xl">
                {userListToggle ? `Cosigned submissions: ${cosignedSubmissions.data.length}` : `User's submissions: ${submissions.length}`}
                <input type="checkbox"
                       className="absolute left-1/2 -translate-x-1/2 w-full h-full peer appearance-none rounded-md"
                       onClick={() => setUserListToggle(!userListToggle)} />
                <span
                  className="w-16 h-10 flex items-center flex-shrink-0 ml-4 p-1 bg-gray-300 rounded-full duration-300 ease-in-out peer-checked:bg-green-400 after:w-8 after:h-8 after:bg-white after:rounded-full after:shadow-md after:duration-300 peer-checked:after:translate-x-6 group-hover:after:translate-x-1"></span>
              </label>
              <UserStatsBar profile={profile.data} />
            </>
          ) :
          profile?.status === "loading" ? <div>Loading...</div> : (
            <div className="flex flex-col items-center">
              <h1>{`${uuid}'s Curations`}</h1>
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
            {/* TODO: CURATOR/ARTIST SEPARATION */}
            <ArchiveTableHeader label="Type" filterKey={"isArtist"} />
            <ArchiveTableHeader label="Co-Signs" />
          </tr>
        </thead>
        {(submissions?.length > 0 || cosignedSubmissions.data?.length > 0) && (
          <tbody>
            <tr className="h-4" />
            {(userListToggle ? cosignedSubmissions.data : submissions)?.map((submission) => {
              const {
                submissionID,
                submitterWallet,
                artistName,
                mediaTitle,
                hotdropAddress,
                isArtist,
                mediaURI,
                submissionTime,
                cosigns,
              } = submission as GenericSubmission;

              return (
                <>
                  <ArchiveTableRow
                    key={`${submissionTime}`}
                    className="hover:opacity-80 cursor-pointer"
                    onClick={() => {
                      router.push(`/submission/${submissionID}`);
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
                    {/*    // TODO: CURATOR/ARTIST SEPARATION */}
                    <ArchiveTableDataCell>{isArtist ? 'Artist' : 'Curator'}</ArchiveTableDataCell>

                    <ArchiveTableDataCell>
                      {/* TODO: CURATOR/ARTIST SEPARATION */}
                      <RatingsMeter hotdropAddress={hotdropAddress} initialCosigns={cosigns} submissionID={submissionID}
                                    submitterWallet={submitterWallet} isArtist={isArtist} />
                    </ArchiveTableDataCell>
                  </ArchiveTableRow>
                  <tr className="h-4" />
                </>
              );
            })}
          </tbody>

        )}
      </table>
      {userListToggle === false && submissions?.length === 0 && (
        <div
          className="w-full mt-4 flex-grow flex justify-center items-center"
          style={{ color: "rgba(105, 105, 105, 1)" }}
        >
          <p className="text-lg italic">{"No Search Results"}</p>
        </div>
      )}

      {userListToggle === true && cosignedSubmissions.data?.length === 0 && (
        <div
          className="w-full mt-4 flex-grow flex justify-center items-center"
          style={{ color: "rgba(105, 105, 105, 1)" }}
        >
          <p className="text-lg italic"> No Search Results </p>
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
  let { uuid } = params;
  const wallet = uuid; // or however you want to get the wallet from the uuid

  const curators = await supabase.from('Curator_Submission_Table').select('*').contains("cosigns", [wallet])
  const artists = await supabase.from('Artist_Submission_Table').select('*').contains("cosigns", [wallet])

  const cosignedSubmissions = {
    data: curators.data.concat(artists.data),
  };

  return {
    props: {
      cosignedSubmissions: cosignedSubmissions,
      submissions: await getSubmissionsWithFilter(null, { submitterWallet: uuid }),
      profile: await getProfileForWallet(uuid),
    }
  };
}

export async function getStaticPaths() {
  const submissionsQuery = await supabase.from('submissions').select();

  if (submissionsQuery.error) throw submissionsQuery.error;

  // IDEA: should we have two pages for each user?
  const UUIDs = submissionsQuery.data.map((submission: GenericSubmission) => {
    return submission.submitterWallet.toString(); // Make sure to generate lower case links as a default
    // Supabase db still has many uppercase links, thus this is necessary
  });

  // can be wallet or username
  const paths = UUIDs.map((uuid) => ({
    params: {
      uuid,
    },
  }));

  return { paths, fallback: true };
}
