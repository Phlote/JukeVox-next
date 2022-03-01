import React from "react";
import styled from "styled-components";
import { useShortenedWallet } from "../components/Account";
import { ArchiveLayout } from "../components/Layouts";
import { BigNumber } from "ethers";
import { useSearchTerm } from "../components/SearchBar";
import { useNFTSearch } from "../hooks/useNFTSearch";
import Image from "next/image";

function Archive() {
  const [searchTerm] = useSearchTerm();
  const curations = useNFTSearch(searchTerm);

  return (
    <ArchiveLayout center={curations.length === 0}>
      <div className="flex flex-col mt-24 min-h-full">
        {curations.length === 0 && (
          <div className="flex flex-col justify-center align-items">
            <div
              className="text-lg italic"
              style={{ color: "rgba(105, 105, 105, 1)" }}
            >
              {"No Search Results"}
            </div>
          </div>
        )}
        {curations.length > 0 && (
          <div className="flex min-h-full">
            <div className="h-16" />
            <table className="table-fixed w-full text-center flex-grow">
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
                  <ArchiveTableHeader label="Media Type" />
                  <ArchiveTableHeader label="Marketplace" />
                  <ArchiveTableHeader label="Curator Wallet" />
                </tr>
              </thead>

              <tbody>
                <tr className="h-4" />
                {curations?.map((curation) => {
                  const {
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
                        style={
                          transactionPending ? { opacity: 0.5 } : undefined
                        }
                        key={`${submissionTime}`}
                      >
                        <ArchiveTableDataCell>
                          {submissionTimeToDate(submissionTime)}
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          {artistName}
                        </ArchiveTableDataCell>
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
                        <ArchiveTableDataCell>
                          {marketplace}
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          <CuratorWallet wallet={curatorWallet} />
                        </ArchiveTableDataCell>
                      </ArchiveTableRow>
                      <tr className="h-4" />
                    </>
                  );
                })}
              </tbody>
            </table>
            <div className="flex-grow" />
          </div>
        )}
      </div>
    </ArchiveLayout>
  );
}

const submissionTimeToDate = (submissionTime: BigNumber | number) => {
  let time = submissionTime;
  if (submissionTime instanceof BigNumber) {
    time = submissionTime.toNumber();
    // do something
  }

  return new Date((time as number) * 1000).toLocaleDateString();
};

const CuratorWallet: React.FC<{ wallet: string }> = ({ wallet }) => {
  const short = useShortenedWallet(wallet);
  return <span>{short}</span>;
};

const ArchiveTableHeader = (props) => {
  const [dropdownOpen, setDropdownOpen] = React.useState<boolean>(false);
  const { label } = props;
  return (
    <th>
      <div className="flex items-center justify-center pb-4">
        {label}
        <div className="w-2" />

        <Image
          onClick={() => {
            setDropdownOpen(!dropdownOpen);
          }}
          className={dropdownOpen ? "-rotate-90" : "rotate-90"}
          src="/chevron.svg"
          width={16}
          height={16}
          alt={`Filter by ${label}`}
        />
      </div>
    </th>
  );
};

const ArchiveTableRow = styled.tr`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  height: 3.5rem;
  align-items: center;
  padding-top: 1rem;
  padding-bottom: 1rem;

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;

const ArchiveTableDataCell = styled.td`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  height: 3.5rem;
  align-items: center;

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;

export default Archive;
