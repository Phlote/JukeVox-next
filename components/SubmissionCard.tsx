import Image from "next/image";
import { PlayButtonAudio, PlayButtonVideo } from "./PlayButton";
import { Username } from "./Username";
import { TwitterIcon, TwitterShareButton } from "next-share";
import React, { useEffect, useRef, useState } from "react";
import tw from "twin.macro";
import styled from "styled-components";
import { RatingsMeter } from "./RatingsMeter";
import { CommentBubble } from "./Comments/CommentBubble";
import { GenericSubmission } from "../types";
import { supabase } from "../lib/supabase";

import { MintingModal } from "./Modals/MintingModal";

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


const SubmissionCard = ({ submission }: { submission: GenericSubmission }) => {
  const [isModalOpen, setModalOpen] = useState(false);
  const openModal = () => setModalOpen(true);
  const closeModal = () => setModalOpen(false);

  const videoEl = useRef(null);
  const [mediaFormat, setMediaFormat] = useState('');

  const setMediaFormatFromSubId = async ()=>{
    const artistSubmission = await supabase
      .from("Artist_Submission_Table")
      .select()
      .match({ submissionID: submission.submissionID });
    setMediaFormat(artistSubmission.data[0].mediaFormat);
  }

  useEffect(()=>{
    if (submission.isArtist){
      setMediaFormatFromSubId();
    }
  })

  return (
    <div>
    <div className="flex flex-col w-80 h-[480px]">
      <div className="w-full h-60 relative">
        {mediaFormat === "video/quicktime" ? (
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
            {mediaFormat?.includes("video") && (
              <PlayButtonVideo el={videoEl} />
            )}
            {mediaFormat?.includes("audio") && (
              <PlayButtonAudio url={submission.mediaURI} />
            )}
          </div>
        </div>
        <div className="h-8" />

        <div className="flex h-16">
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
              wallet={submission.submitterWallet}
              linkToProfile
            />
          </div>
          
        </div>
        <div className="flex h-12">
            <button 
            className="bg-neutral-700 text-white rounded-lg px-8 py-2 text-base font-medium hover:bg-stone-300 focus:outline-none focus:ring-2 focus:ring-white-300"
            id="open-btn"
            onClick={openModal}>Mint</button>
          </div>


        <div className="h-8" />
        <div className="flex">
          <div className="flex flex-1 items-center gap-2">
            <TwitterShareButton
              className="w-24"
              url={`${
                process.env.NEXT_PUBLIC_URL ??
                process.env.NEXT_PUBLIC_VERCEL_URL
              }/submission/${submission.submissionID}`}
              title={`Have you heard ${submission.mediaTitle}? It's a 💎`}
            >
              <TwitterIcon size={32} round />
            </TwitterShareButton>
            {/*<CommentBubble />*/}
          </div>
          <div className="flex flex-10 justify-center items-center">
            {/* TODO: CURATOR/ARTIST SEPARATION */}
            <RatingsMeter hotdropAddress={submission.hotdropAddress} submissionID={submission.submissionID} submitterWallet={submission.submitterWallet}
                          initialCosigns={submission.cosigns} isArtist={submission.isArtist}/>
          </div>
        </div>
      </SubmissionCardDetails>
    </div>
    {isModalOpen? <MintingModal isOpen={isModalOpen} onClose={closeModal}>{submission}</MintingModal>:null}
  </div>
)}

export default SubmissionCard;
