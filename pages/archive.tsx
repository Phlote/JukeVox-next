import React from "react";
import styled from "styled-components";
import { ShortenedWallet } from "../components/Account";
import { ArchiveLayout } from "../components/Layouts";
import { BigNumber, ethers } from "ethers";
import { useSearchTerm } from "../components/SearchBar";
import { useNFTSearch, useNFTSearchFilters } from "../hooks/web3/useNFTSearch";
import Image from "next/image";
import { DropdownList } from "../components/DropdownList";
import { useOnClickOut } from "../hooks/useOnClickOut";
import Close from "../public/close.svg";
import classNames from "classnames";
import tw from "twin.macro";
import { usePhlote } from "../hooks/web3/usePhlote";
import { RatingsMeter } from "../components/RatingsMeter";
import {
  ArchiveTableHeader,
  ArchiveTableRow,
  ArchiveTableDataCell,
  SubmissionDate,
} from "../components/Tables/archive";

function Archive() {
  const [searchTerm] = useSearchTerm();
  const curations = useNFTSearch(searchTerm);
  const phlote = usePhlote();

  return (
    <ArchiveLayout>
      <div className="flex flex-col">
        <table className="table-fixed w-full text-center mt-8">
          <thead>
            <tr
              style={{
                borderBottom: "1px solid white",
                paddingBottom: "1rem",
              }}
            >
              <ArchiveTableHeader label="Date" />
              <ArchiveTableHeader label="Artist" />
              <ArchiveTableHeader label="Title" />
              <ArchiveTableHeader label="Media Type" filterKey={"mediaType"} />
              <ArchiveTableHeader label="Marketplace" filterKey="marketplace" />
              <ArchiveTableHeader
                label="Curator Wallet"
                filterKey="curatorWallet"
              />
              <ArchiveTableHeader label="Rating" />
            </tr>
          </thead>

          {curations.length > 0 && (
            <tbody>
              <tr className="h-4" />
              {curations?.map((curation) => {
                const {
                  id,
                  curatorWallet,
                  artistName,
                  mediaTitle,
                  mediaType,
                  mediaURI,
                  marketplace,
                  transactionPending,
                  submissionTime,
                } = curation;

                return (
                  <>
                    <ArchiveTableRow
                      style={transactionPending ? { opacity: 0.5 } : undefined}
                      key={`${submissionTime}`}
                    >
                      <ArchiveTableDataCell>
                        <SubmissionDate submissionTimestamp={submissionTime} />
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{artistName}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <a
                          rel="noreferrer"
                          target="_blank"
                          href={mediaURI}
                          className="underline"
                        >
                          {mediaTitle}
                        </a>
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>{marketplace}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <ShortenedWallet wallet={curatorWallet} />
                      </ArchiveTableDataCell>
                      <ArchiveTableDataCell>
                        <RatingsMeter
                          editionId={id}
                          txnPending={transactionPending}
                        />
                      </ArchiveTableDataCell>
                    </ArchiveTableRow>
                    <tr className="h-4" />
                  </>
                );
              })}
            </tbody>
          )}
        </table>
        {curations.length === 0 && (
          <div
            className="w-full mt-4 flex-grow flex justify-center items-center"
            style={{ color: "rgba(105, 105, 105, 1)" }}
          >
            <p className="text-lg italic">{"No Search Results"}</p>
          </div>
        )}
      </div>
    </ArchiveLayout>
  );
}

export default Archive;
