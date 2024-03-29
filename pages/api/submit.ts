import cuid from "cuid";
import { NextApiRequest, NextApiResponse } from "next";
import { nodeElasticClient } from "../../lib/elastic-app-search";
import { supabase } from "../../lib/supabase";
import { GenericSubmission, CuratorSubmission, ArtistSubmission } from "../../types";
import { submissionToElasticSearchDocument } from "../../utils";
import { storeSubmissionOnIPFS } from "../../utils/moralis";

const { ELASTIC_ENGINE_NAME } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { submission, wallet } = request.body;

  console.log({ submission });

  try {
    const submissionWithSubmitterInfo: ArtistSubmission | CuratorSubmission = {
      submitterWallet: wallet,
      mediaTitle: submission.mediaTitle,
      mediaURI: submission.mediaURI,
      artistName: submission.artistName,
      hotdropAddress: submission.hotdropAddress,
      isArtist: submission.isArtist
    };

    const playlistsQuery = await supabase
      .from("Playlists_Table")
      .select()
      .match({ playlistName: submission.playlist });

    if (playlistsQuery.data.length > 0) {
      submissionWithSubmitterInfo.playlistIDs = [playlistsQuery.data[0].playlistID];
    }

    console.log({ submissionWithSubmitterInfo });

    let submissionsInsert = await (async () => {
      if (submissionWithSubmitterInfo.isArtist) {
        // submissionWithSubmitterInfo.nftMetadata = await storeSubmissionOnIPFS(submissionWithSubmitterInfo); do we need this?

        submissionWithSubmitterInfo.mediaFormat = submission.mediaFormat;

        return supabase
          .from('Artist_Submission_Table')
          .insert([submissionWithSubmitterInfo]);
      } else {
        return supabase
          .from('Curator_Submission_Table')
          .insert([submissionWithSubmitterInfo]);
      }
    })();

    console.log({ submissionsInsert });

    if (submissionsInsert.error) throw submissionsInsert.error;

    const submissionRes = submissionsInsert.data[0] as ArtistSubmission | CuratorSubmission;

    // await supabase.from("comments").insert([
    //   {
    //     threadId: submissionRes.submissionID,
    //     slug: `submission-root-${cuid.slug()}`,
    //     authorId: submissionRes.submitterWallet,
    //     isApproved: true,
    //   },
    // ]);
    //
    await indexSubmission(submissionRes);

    response.status(200).send(submissionWithSubmitterInfo);
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}

const indexSubmission = async (submission: GenericSubmission) => {
  const document = submissionToElasticSearchDocument(submission);
  const res = await nodeElasticClient.indexDocuments(ELASTIC_ENGINE_NAME, [
    document,
  ]);
  // Does not throw on indexing error, see: https://github.com/elastic/app-search-node
  if (res[0].errors.length > 0) throw res;
};
