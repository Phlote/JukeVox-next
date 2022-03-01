import React from "react";
import styled from "styled-components";
import { ShortenedWallet } from "../components/Account";
import { ArchiveLayout } from "../components/Layouts";
import { BigNumber, ethers } from "ethers";
import { useSearchTerm } from "../components/SearchBar";
import {
  useGetAllNFTs,
  useNFTSearch,
  useNFTSearchFilters,
} from "../hooks/web3/useNFTSearch";
import Image from "next/image";
import { DropdownList } from "../components/DropdownList";
import { useOnClickOut } from "../hooks/useOnClickOut";
import Close from "../public/close.svg";
import classNames from "classnames";

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
                  <ArchiveTableHeader
                    label="Media Type"
                    filterKey={"mediaType"}
                  />
                  <ArchiveTableHeader
                    label="Marketplace"
                    filterKey="marketplace"
                  />
                  <ArchiveTableHeader
                    label="Curator Wallet"
                    filterKey="curatorWallet"
                  />
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
                          <ShortenedWallet wallet={curatorWallet} />
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

const ArchiveTableHeader = (props) => {
  const [dropdownOpen, setDropdownOpen] = React.useState<boolean>(false);
  const { label, filterKey } = props;
  const ref = React.useRef();
  useOnClickOut(ref, () => setDropdownOpen(false));
  const [filters, setFilters] = useNFTSearchFilters();

  const isActiveFilter = !!filters[filterKey];

  return (
    <th>
      <div className="w-full flex justify-center">
        <div
          ref={ref}
          className={classNames(
            "flex items-center justify-center mb-4 relative px-1",
            {
              "rounded-full": isActiveFilter,
              "border-2": isActiveFilter,
              "border-white": isActiveFilter,
            }
          )}
        >
          {isActiveFilter ? (
            <ArchiveFilterLabel filter={filters[filterKey]} />
          ) : (
            label
          )}
          {filterKey && (
            <>
              <div className="w-2" />

              <Image
                onClick={() => {
                  setDropdownOpen((current) => !current);
                }}
                className={dropdownOpen ? "-rotate-90" : "rotate-90"}
                src="/chevron.svg"
                width={16}
                height={16}
                alt={`Filter by ${label}`}
              />

              {dropdownOpen && (
                <ArchiveDropdown
                  label={label}
                  filterKey={filterKey}
                  close={() => setDropdownOpen(false)}
                />
              )}
            </>
          )}
        </div>
      </div>
    </th>
  );
};

const ArchiveFilterLabel: React.FC<{ filter: string }> = ({ filter }) => {
  const isAddress = ethers.utils.isAddress(filter);
  if (isAddress) return <ShortenedWallet wallet={filter} />;
  else return <span>{filter}</span>;
};

const ArchiveDropdown: React.FC<{
  label: string;
  filterKey: string;
  close: () => void;
}> = (props) => {
  //TODO: grey out fields that are usually present but not in current results (this is a maybe)
  const { filterKey, close } = props;
  const curations = useGetAllNFTs();
  const [filters, setFilters] = useNFTSearchFilters();

  const updateFilter = (val) => {
    setFilters((current) => {
      const updated = { ...current };
      if (updated[filterKey] === val) {
        delete updated[filterKey];
      } else updated[filterKey] = val;
      return updated;
    });
  };

  const options = Array.from(
    new Set(curations.map((curation) => curation[filterKey]))
  ) as string[];

  return (
    <div
      className="absolute z-10 h-64 w-64 mb-4 top-10"
      style={{ backgroundColor: "#1d1d1d" }}
    >
      <DropdownList
        value={filters[filterKey]}
        onChange={updateFilter}
        fields={options}
        close={close}
      />
    </div>
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
