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
    </div>
  )
}

export default SubmissionCard;
