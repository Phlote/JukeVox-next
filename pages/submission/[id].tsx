import { TwitterIcon, TwitterShareButton } from "next-share";
import Image from "next/image";
import { useRouter } from "next/router";
import React from "react";
import styled from "styled-components";
import tw from "twin.macro";
import Layout from "../../components/Layouts";
import { Username } from "../../components/Username";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";

export default function SubmissionPage(props) {
  const { submission } = props as { submission: Submission };
  const router = useRouter();

  if (router.isFallback) {
    //TODO better loading
    return <div>Loading...</div>;
  }

  return (
    <div className="w-80 flex flex-col">
      <div className="w-full h-60 flex-none relative">
        <Image
          src={"/default_submission_image.jpeg"}
          layout="fill"
          alt="submission image"
        />
      </div>

      <SubmissionCardDetails>
        <a href={submission.mediaURI} className="text-3xl hover:opacity-50">
          {submission.mediaTitle}
        </a>
        <div className="h-8" />

        <div className="flex">
          <div>
            <h2 className="text-base opacity-60"> Artist</h2>
            <div className="h-2" />
            <a>{submission.artistName}</a>
          </div>
          <div className="flex-grow" />
          <div>
            <h2 className="text-base opacity-60"> Curator</h2>
            <div className="h-2" />
            <Username
              username={submission.username}
              wallet={submission.curatorWallet}
              linkToProfile
            />
          </div>
        </div>
        <div className="h-8" />
        <TwitterShareButton
          url={`${process.env.NEXT_PUBLIC_URL}/submission/${submission.id}`}
          title={`Have you heard ${submission.mediaTitle}? It's a 💎.`}
        >
          <TwitterIcon size={32} round />
        </TwitterShareButton>
      </SubmissionCardDetails>
    </div>
  );
}

const SubmissionCardDetails = styled.div`
  ${tw`p-4 bg-phlote-ff-modal`}
  border-radius: 0px;
  @supports (backdrop-filter: none) {
    background: rgba(122, 122, 122, 0.08);
    box-shadow: 0px 0px 55px rgba(42, 45, 61, 0.08),
      inset 0px 0px 90px rgba(0, 0, 0, 0.05);
    backdrop-filter: blur(60px);
  }
`;

SubmissionPage.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center flex-grow">
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

  return {
    props: {
      submission: submissionsQuery.data[0] as Submission,
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
