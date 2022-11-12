import Image from "next/image";
import React from "react";
import Clock from "./Clock";

export const Footer: React.FC = (props) => {
  return (
    <div className="grid-cols-3 gap-4 absolute h-14 bottom-0 w-screen bg-phlote-container sm:grid hidden">
      <div className="my-auto ml-8">
        <Clock />
      </div>
      <div className="flex items-center justify-center">
        <Image src="/favicon.svg" height={16} width={16} alt={"Gem"} />
        <div className="w-2" />
        Finding Internet Gems since 2022
      </div>

      <div className="flex flex-row items-center justify-end mr-8">
        <div className="my-auto space-x-4">
          <a
            rel="noreferrer"
            target="_blank"
            href={"https://www.notion.so/Phlote-DAO-Start-Here-7aba7e7e8cc7453a8135ad516002f36a"}
            className="underline"
          >
            Documentation
          </a>

          <a
            rel="noreferrer"
            target="_blank"
            href={"https://www.phlote.co/"}
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
