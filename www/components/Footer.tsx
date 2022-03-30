import styled from "styled-components";
import React from "react";
import Image from "next/image";
import Clock from "./Clock";

export const Footer: React.FC = (props) => {
  return (
    <div className="grid grid-cols-3 gap-4 absolute h-14 bottom-0 w-screen bg-phlote-container">
      <div className="my-auto ml-8">
        <Clock />
      </div>
      <div className="flex items-center justify-center">
        <Image src="/favicon.svg" height={16} width={16} alt={"Gem"} />
        <div className="w-2" />
        Finding Internet Gems since 2022
      </div>

      <div className="flex justify-end mr-8">
        <div className="my-auto space-x-4">
          {/* TODO: make phlote <a></a> */}
          <a
            rel="noreferrer"
            target="_blank"
            href={"https://twitter.com/teamphlote"}
            className="underline"
          >
            About Phlote
          </a>
          <a
            rel="noreferrer"
            target="_blank"
            href={"https://phlote.mirror.xyz/y"}
            className="underline"
          >
            Blog
          </a>
          <a
            rel="noreferrer"
            target="_blank"
            href={"https://phlote.typeform.com/guestlist"}
            className="underline"
          >
            GuestList
          </a>
        </div>
      </div>
    </div>
  );
};
