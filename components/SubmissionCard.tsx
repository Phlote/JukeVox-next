import Image from "next/image";
import { PlayButtonAudio, PlayButtonVideo } from "./PlayButton";
import { Username } from "./Username";
import { TwitterIcon, TwitterShareButton } from "next-share";
import React, { useRef } from "react";
import tw from "twin.macro";
import styled from "styled-components";

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

const SubmissionCard = ({ submission }) => {

  const videoEl = useRef(null);

  return (
    <div className="flex flex-col w-80 m-auto">
      <div className="w-full h-60 relative">
        {submission.mediaFormat === "video/quicktime" ? (
          <video
            className="absolute bottom-0"
            src={submission.mediaURI}
            ref={videoEl}
          />
        ) : (
          <Image
            src={"/default_submission_image.jpeg"}
            layout="fill"
            alt="submission image"
          />
        )}
      </div>
      <SubmissionCardDetails>
        <div className="flex">
          <div>
            <a
              href={submission.mediaURI}
              className="text-3xl hover:opacity-50"
            >
              {submission.mediaTitle}
            </a>
          </div>
          <div className="flex-grow" />
          <div className="flex items-center">
            {submission.mediaFormat?.includes("video") && (
              <PlayButtonVideo el={videoEl} />
            )}
            {submission.mediaFormat?.includes("audio") && (
              <PlayButtonAudio url={submission.mediaURI} />
            )}
          </div>
        </div>
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
          url={`${
            process.env.NEXT_PUBLIC_URL ??
            process.env.NEXT_PUBLIC_VERCEL_URL
          }/submission/${submission.id}`}
          title={`Have you heard ${submission.mediaTitle}? It's a 💎`}
        >
          <TwitterIcon size={32} round />
        </TwitterShareButton>
      </SubmissionCardDetails>
    </div>
  )
}

export default SubmissionCard;
