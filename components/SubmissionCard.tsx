import Image from "next/image";
import { PlayButtonAudio, PlayButtonVideo } from "./PlayButton";
import { Username } from "./Username";
import { TwitterIcon, TwitterShareButton } from "next-share";
import React, { useRef } from "react";
import tw from "twin.macro";
import styled from "styled-components";
import { RatingsMeter } from "./RatingsMeter";
import { CommentBubble } from "./Comments/CommentBubble";

const SubmissionCardDetails = styled.div`
  ${tw`p-4 bg-phlote-ff-modal`}
  border-radius: 0px;
  flex: 1;
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
    <div className="flex flex-col w-80 h-[480px]">
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
        <div className="flex h-12 items-center">
          <div>
            <a
              href={submission.mediaURI}
              className="text-3xl hover:opacity-50 break-words"
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

        <div className="flex h-24">
          <div>
            <h2 className="text-base opacity-60 break-words"> Artist</h2>
            <div className="h-2" />
            <a>{submission.artistName}</a>
          </div>
          <div className="flex-grow" />
          <div>
            <h2 className="text-base opacity-60 break-words"> Curator</h2>
            <div className="h-2" />
            <Username
              username={submission.username}
              wallet={submission.curatorWallet}
              linkToProfile
            />
          </div>
        </div>
        <div className="h-8" />
        <div className="flex">
          <div className="flex flex-1 items-center gap-2">
            <TwitterShareButton
              className="w-24"
              url={`${
                process.env.NEXT_PUBLIC_URL ??
                process.env.NEXT_PUBLIC_VERCEL_URL
              }/submission/${submission.id}`}
              title={`Have you heard ${submission.mediaTitle}? It's a 💎`}
            >
              <TwitterIcon size={32} round />
            </TwitterShareButton>
            {/*<CommentBubble />*/}
          </div>
          <div className="flex flex-10 justify-center items-center">
            <RatingsMeter submissionId={submission.id} submitterWallet={submission.wallet} initialCosigns={submission.cosigns}/>
          </div>
        </div>
        </SubmissionCardDetails>
    </div>
  )
}

export default SubmissionCard;
