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
import { MintingModal, useMintingModalOpen, useMintingModalSubmission } from "./Modals/MintingModal";
import { useIsCurator } from "../hooks/useIsCurator";
import { useMoralis } from "react-moralis";
import ReactTooltip from "react-tooltip";
import MintButton from "./MintButton";
import { InfoIcon } from "../icons/InfoIcon";
import DownloadButton from "./DownloadButton";

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


const SubmissionCard = ({ submission, key }: { submission: GenericSubmission, key?: number }) => {
  const [open, setOpen] = useMintingModalOpen();
  const [submissionAtom, setSubmissionAtom] = useMintingModalSubmission();
  const videoEl = useRef(null);
  const [mediaFormat, setMediaFormat] = useState('');
  const { isWeb3Enabled, account } = useMoralis();

  const isCuratorData = useIsCurator();
  const isCurator = isCuratorData.data?.isCurator;

  const canCosign = account && isCurator && submission.submitterWallet?.toLowerCase() !== account.toLowerCase();

  let cantMintMessage = '';
  if (account) {
    if (!isCurator) {
      cantMintMessage = 'Need phlote tokens to mint.';
    }
    if (submissionAtom.submitterWallet?.toLowerCase() === account.toLowerCase()) {
      cantMintMessage = "Can't mint own submission."
    }
  } else {
    cantMintMessage = 'Connect your wallet to mint.';
  }
  // gotta define what info to show the user when they can't mint

  const mint = () =>{
    setSubmissionAtom(submission);
    setOpen(true);
  }

  const setMediaFormatFromSubId = async () => {
    const artistSubmission = await supabase
      .from("Artist_Submission_Table")
      .select()
      .match({ submissionID: submission.submissionID });
    setMediaFormat(artistSubmission.data[0].mediaFormat);
  }

  useEffect(() => ReactTooltip.rebuild() as () => (void), []);

  useEffect(() => {
    if (submission.isArtist) {
      setMediaFormatFromSubId();
    }
  })
  

  return (
    <div className="flex flex-col w-80 h-[480px]" key={key}>
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
            objectFit="cover"
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
          {submission.cosigns?.length === 5 && submission.hotdropAddress != "" && submission.isArtist ?
            <div className="flex h-12 mt-1" data-tip={cantMintMessage}>
              <MintButton color="bg-indigo-500" text="Loading..." hotdropAddress={submission.hotdropAddress}
              hoverColor="bg-indigo-300" />
            
              <button className='ml-3 mr-3 hover:opacity-50' onClick={mint}><InfoIcon/></button>
              {/*<a className="flex justify-center items-center bg-gray-200 text-gray-800 py-2 px-4 rounded-lg ml-2 hover:bg-gray-300" target='_blank' href={submission.mediaURI}>*/}
              {/*  <span>Download Files</span>*/}
              {/*</a>*/}
              <DownloadButton id={submission.submissionID} hotdropAddress={submission.hotdropAddress} text="Download" />
            </div>
            :
            null
          }

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
              <RatingsMeter hotdropAddress={submission.hotdropAddress} submissionID={submission.submissionID}
                            submitterWallet={submission.submitterWallet}
                            initialCosigns={submission.cosigns} isArtist={submission.isArtist} />
            </div>
          </div>
        </SubmissionCardDetails>
      </div>
  )
}

export default SubmissionCard;
