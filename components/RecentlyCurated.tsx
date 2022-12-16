import React, { useEffect, useRef, useState } from "react";
import { useSearchFilters } from "../hooks/useSubmissions";
import { Submission } from "../types";
import SubmissionCard from "./SubmissionCard";
import AliceCarousel from "react-alice-carousel";
import { HollowInputContainer } from "./Hollow";
import { ArrowLeft, ArrowRight } from "../icons/Arrows";

export default function RecentlyCurated({ account, setOpen, setConnectWalletOpen, submissions }) {
  const [cosignedSubs, setCosignedSubs] = useState<any>([]);
  const [currSlide, setCurrSlide] = useState(0);
  const [next, setNext] = useState(false);
  const [prev, setPrev] = useState(true);

  const onSlideChanged = (e) => {
    setCurrSlide(e.item);
  };

  useEffect(()=>{
    setPrev(currSlide < 1)
    setNext(currSlide >= cosignedSubs.length - 2)
  }, [currSlide, cosignedSubs]);

  const slideNext = () => {
    let nextEl = document.getElementsByClassName('alice-carousel__next-btn-item')[0];
    nextEl.click(); // The way specified in the docs wouldn't animate...
  };

  const slidePrev = () => {
    let prevEl = document.getElementsByClassName('alice-carousel__prev-btn-item')[0];
    prevEl.click();
  };

  useEffect(() => {
    const cosSubs = [];
    submissions?.data?.map((submission: Submission, i) => {
        cosSubs.push(<SubmissionCard key={i} submission={submission} />)
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
      <div className="w-8 h-8 sm:w-32 sm:h-32">
        <button onClick={slidePrev} disabled={prev} className='disabled:opacity-30 transition'>
          <ArrowLeft className="m-0 w-8 h-8 sm:w-32 sm:h-32 sm:m-0 sm:w-auto" />
        </button>
      </div>
      {/* Desktop */}
      <div className="hidden sm:flex w-full flex-col justify-center items-center pt-10 gap-4">
        <h1 className="hidden text-center italic lg:text-xl 2xl:text-4xl">
          Decentralized music label run by a passionate community of music lovers.{" "}
        </h1>
        <h3 className="hidden text-center italic lg:text-lg 2xl:text-2xl opacity-70">
          Artist submissions the receive 5 co-signs are minted every Tuesday on Zora.{" "}
        </h3>
        <div className="w-[320px] lg:w-[670px] xl:w-[1100px] 2xl:w-[1400px] flex justify-center">
          {/*The Carousel causes the error*/}
          {cosignedSubs && cosignedSubs.length !== 0 && <AliceCarousel
              activeIndex={currSlide}
              responsive={responsive}
              mouseTracking
              items={cosignedSubs}
              controlsStrategy="alternate"
              disableDotsControls
              onSlideChanged={onSlideChanged}
          />}
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
          {cosignedSubs && cosignedSubs.length !== 0 && <AliceCarousel
              responsive={responsive}
              mouseTracking
              items={cosignedSubs}
              controlsStrategy="alternate"
              disableDotsControls
          />}
        </div>
        <h3 className="text-center italic opacity-70 font-light">
          These are some of the most wanted songs as voted on by the Phlote community.
        </h3>
      </div>
      <div className="w-8 h-8 sm:w-32 sm:h-32">
        <button onClick={slideNext} disabled={next} className='disabled:opacity-30 transition'>
          <ArrowRight className="m-0 w-8 h-8 sm:w-32 sm:h-32 sm:m-0 sm:w-auto" />
        </button>
      </div>
    </section>
  );
}
