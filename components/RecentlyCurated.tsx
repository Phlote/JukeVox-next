import React, { useEffect, useState } from "react";
import { useSearchFilters } from "../hooks/useSubmissions";
import { Submission } from "../types";
import SubmissionCard from "./SubmissionCard";
import AliceCarousel from "react-alice-carousel";
import { HollowInputContainer } from "./Hollow";

export default function RecentlyCurated({ account, setOpen, setConnectWalletOpen, submissions }) {
  const [cosignedSubs, setCosignedSubs] = useState<any>([])

  useEffect(() => {
    console.log(submissions);
    const cosSubs = [];
    submissions?.data?.map((submission: Submission) => {
        // cosSubs.push(<SubmissionCard submission={submission} />)
      }
    )
    setCosignedSubs(cosSubs);
  }, []);

  const responsive = {
    640: { items: 1 },
    1024: { items: 2 },
    1280: { items: 3 },
    1700: { items: 4 },
  };
  // TODO: Fetch number of items at a time for faster loading times

  return (
    <section className="flex items-center justify-center sm:py-20 sm:mt-5">
      {/* Desktop */}
      <div className="hidden sm:flex w-full flex-col justify-center items-center pt-10 gap-4">
        <h1 className="hidden text-center italic lg:text-xl 2xl:text-4xl">
          Decentralized music label run by a passionate community of music lovers.{" "}
        </h1>
        <h3 className="hidden text-center italic lg:text-lg 2xl:text-2xl opacity-70">
          Artist submissions the receive 5 co-signs are minted every Tuesday on Zora.{" "}
        </h3>
        <div className="w-[320px] lg:w-[670px] xl:w-[1100px] 2xl:w-[1400px] flex justify-center space-x-5">
          {/*The Carousel causes the error*/}
          {/*{cosignedSubs[0]}*/}
        </div>
        <div className="h-2"></div>
        <h3 className="text-center italic opacity-70 font-light lg:text-lg 2xl:text-2xl">
          Community Curated by Team Phlote
        </h3>
        <div className="h-2"></div>
        <div className="w-80 h-16 cursor-pointer hover:opacity-75 shadow-sm">
          <HollowInputContainer
            style={{ justifyContent: "center", border: "1px solid white" }}
            onClick={() => {
              if (account) setOpen(true);
              else setConnectWalletOpen(true);
            }}
          >
            {account ? "Submit music to Phlote" : "Connect"}
          </HollowInputContainer>
        </div>
      </div>
      {/* Mobile */}
      <div className="sm:hidden w-9/12 sm:w-8/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
        {/*<h1 className="text-center italic text-5xl stroke-text">*/}
        {/*  Recently Curated*/}
        {/*</h1>*/}
        <div className="w-[320px] lg:w-[670px] xl:w-[1100px] 2xl:w-[1400px] flex justify-center">
          {/*{cosignedSubs[0]}*/}
        </div>
        <h3 className="text-center italic opacity-70 font-light">
          These are some of the most wanted songs as voted on by the Phlote community.
        </h3>
      </div>
    </section>
  );
}
