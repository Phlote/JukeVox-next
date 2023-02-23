import { useRouter } from "next/router";
import React, { useEffect, useRef, useState } from "react";
import CommentSection from "../../components/Comments/CommentSection";
import Layout from "../../components/Layouts";
import { CommentsContextProvider } from "../../hooks/useComments";
import { supabase } from "../../lib/supabase";
import { ArtistSubmission, CuratorSubmission } from "../../types";
import SubmissionCard from "../../components/SubmissionCard";
import { getSubmissionById } from "../../utils/supabase";
import { ArrowLeft, ArrowRight } from "../../icons/Arrows";

export default function SubmissionPage(props: {
  submission: ArtistSubmission | CuratorSubmission;
  submissionFileType: string | null;
}) {
  const { submission, submissionFileType } = props;
  const router = useRouter();
  const [prev, setPrev] = useState(false);
  const [next, setNext] = useState(false);

  useEffect(() => {
    if (submission) {
      //TODO: cant increment and decrement, must fetch from db
      // let prevId = submission.submissionID - 1;
      // let nextId = submission.submissionID + 1;

      // getSubmissionById(prevId).then(v => {
      //   setPrev(v.data.length > 0);
      // });
      // getSubmissionById(nextId).then(v => {
      //   setNext(v.data.length > 0);
      // });
    }
  }, [submission]);

  if (router.isFallback) {
    //TODO better loading
    return <div>Loading...</div>;
  }

  return (
    <CommentsContextProvider threadId={submission.submissionID}>
      <div className="min-w-full mt-32">
        <div className="flex justify-center min-w-full mb-8">
          <div className="my-auto sm:left-10 w-8 h-8 sm:w-32 sm:h-32">
            {next &&
                <a
                    href={`/submission/${submission.submissionID + 1}`}
                >
                    <ArrowLeft className="m-0 w-8 h-8 sm:w-32 sm:h-32 sm:m-0 sm:w-auto" />
                </a>
            }
          </div>
          <SubmissionCard submission={submission} />
          <div className="my-auto sm:right-10 w-8 h-8 sm:w-32 sm:h-32">
            {prev &&
                <a
                    // href={`/submission/${submission.submissionID - 1}`} TODO: submission id is no longer an order
                >
                    <ArrowRight className="m-0 w-8 h-8 sm:w-32 sm:h-32 sm:m-0 sm:w-auto" />
                </a>
            }
          </div>
        </div>
        <div className="max-w-prose mx-auto flex-grow">
          <CommentSection submissionWallet={submission.submitterWallet}/>
        </div>
      </div>
    </CommentsContextProvider>
  );
}

SubmissionPage.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto h-full w-full">
        {page}
      </div>
    </Layout>
  );
};

export async function getStaticProps({ params }) {
  const { id } = params;

  const isArtistQuery = await supabase
    .from('submissions')
    .select()
    .match({ submissionID: id });

  if (isArtistQuery.error) throw isArtistQuery.error;

  const isArtist = isArtistQuery.data[0].isArtist;

  let tableName = 'Curator_Submission_Table';
  if (isArtist) tableName = 'Artist_Submission_Table';

  const submissionsQuery = await supabase
    .from(tableName)
    .select()
    .match({ submissionID: id });

  if (submissionsQuery.error) throw submissionsQuery.error;

  const submission = submissionsQuery.data[0] as ArtistSubmission | CuratorSubmission;
  let submissionFileType = null;

  if (submission.isArtist) {
    try {
      const response = await fetch(submission.mediaURI, { method: "HEAD" });
      submissionFileType = response.headers.get("content-type");
    } catch (e) {
      console.error(e);
    }
  }

  return {
    props: {
      submission,
      submissionFileType,
    },
    // just in case
    revalidate: 3600,
  };
}

export async function getStaticPaths() {
  const submissionsQuery = await supabase.from('submissions').select();
  if (submissionsQuery.error) throw submissionsQuery.error;

  const paths = submissionsQuery.data.map(({ submissionID }) => ({
    params: {
      id: submissionID
    },
  }));

  console.log(paths);

  return { paths, fallback: true };
}
