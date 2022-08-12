import { useRouter } from "next/router";
import React, { useRef } from "react";
import CommentSection from "../../components/Comments/CommentSection";
import Layout from "../../components/Layouts";
import { CommentsContextProvider } from "../../hooks/useComments";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";
import SubmissionCard from "../../components/SubmissionCard";

// interface SubmissionPageProps {
//   submission: Submission;
//   submissionFileType: string;
//   getLayout: (any) => JSX.Element;
// }

export default function SubmissionPage(props: {
  submission: Submission;
  submissionFileType: string | null;
}) {
  const { submission, submissionFileType } = props;
  const router = useRouter();

  if (router.isFallback) {
    //TODO better loading
    return <div>Loading...</div>;
  }

  return (
    <CommentsContextProvider threadId={submission.id}>
      <div className="min-w-full mt-32">
        <div className="flex justify-center min-w-full mb-8">
          <SubmissionCard submission={submission} submissionFileType={submissionFileType} />
        </div>
        <div className="max-w-prose mx-auto flex-grow">
          <CommentSection />
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

  const submissionsQuery = await supabase
    .from("submissions")
    .select()
    .match({ id });

  if (submissionsQuery.error) throw submissionsQuery.error;

  const submission = submissionsQuery.data[0] as Submission;
  let submissionFileType = null;
  if (submission.mediaType === "File") {
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
  const submissionsQuery = await supabase.from("submissions").select();

  if (submissionsQuery.error) throw submissionsQuery.error;

  const paths = submissionsQuery.data.map(({ id }) => ({
    params: {
      id: id.toString(),
    },
  }));

  return { paths, fallback: true };
}
