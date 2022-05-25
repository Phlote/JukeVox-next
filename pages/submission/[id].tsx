import { ethers } from "ethers";
import { TwitterIcon, TwitterShareButton } from "next-share";
import Image from "next/image";
import { useRouter } from "next/router";
import React from "react";
import styled from "styled-components";
import tw from "twin.macro";
import Layout from "../../components/Layouts";
import { Username } from "../../components/Username";
import { initializeApollo } from "../../lib/graphql/apollo";
import {
  GetAllSubmissionIDsDocument,
  GetAllSubmissionIDsQuery,
  GetSubmissionByIdDocument,
  GetSubmissionByIdQuery,
  Submission,
} from "../../lib/graphql/generated";

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
              // username={submission.username}
              wallet={ethers.utils.hexlify(submission.submitterWallet)}
              linkToProfile
            />
          </div>
        </div>
        <div className="h-8" />
        <TwitterShareButton
          url={`${
            process.env.NEXT_PUBLIC_URL ?? process.env.NEXT_PUBLIC_VERCEL_URL
          }/submission/${submission.id}`}
          title={`Have you heard ${submission.mediaTitle}? It's a 💎`}
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
  const { id } = params as { id: string };
  const apolloClient = initializeApollo();
  const res = await apolloClient.query<GetSubmissionByIdQuery>({
    query: GetSubmissionByIdDocument,
    variables: { id: id.toLowerCase() },
  });

  return {
    props: {
      submission: res.data.submission,
    },
    // just in case
    revalidate: 60,
  };
}

export async function getStaticPaths() {
  const apolloClient = initializeApollo();
  const res = await apolloClient.query<GetAllSubmissionIDsQuery>({
    query: GetAllSubmissionIDsDocument,
  });

  const paths = res.data.submissions.map(({ id }) => ({
    params: {
      id,
    },
  }));

  return { paths, fallback: true };
}
