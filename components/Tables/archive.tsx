import classNames from "classnames";
import { BigNumber, ethers } from "ethers";
import Image from "next/image";
import React from "react";
import styled from "styled-components";
import tw from "twin.macro";
import { useOnClickOut } from "../../hooks/useOnClickOut";
import {
  useNFTSearchFilters,
  useSubmissions,
} from "../../hooks/useSubmissions";
import { DropdownList } from "../DropdownList";
import { Username } from "../Username";

export const ArchiveTableHeader = (props) => {
  const [dropdownOpen, setDropdownOpen] = React.useState<boolean>(false);
  const { label, filterKey } = props;
  const ref = React.useRef();
  useOnClickOut(ref, () => setDropdownOpen(false));
  const [filters] = useNFTSearchFilters();

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

export const ArchiveFilterLabel: React.FC<{ filter: string }> = ({
  filter,
}) => {
  const isAddress = ethers.utils.isAddress(filter);
  if (isAddress) return <Username wallet={filter} />;
  else return <span>{filter}</span>;
};

export const SubmissionDate: React.FC<{
  submissionTimestamp: BigNumber | number;
}> = ({ submissionTimestamp }) => {
  return <span>{submissionTimeToDate(submissionTimestamp)}</span>;
};

const submissionTimeToDate = (submissionTimestamp: BigNumber | number) => {
  let time = submissionTimestamp;
  if (submissionTimestamp instanceof BigNumber) {
    time = submissionTimestamp.toNumber();
  }

  return new Date((time as number) * 1000).toLocaleDateString();
};

export const ArchiveDropdown: React.FC<{
  label: string;
  filterKey: string;
  close: () => void;
}> = (props) => {
  //TODO: grey out fields that are usually present but not in current results (this is a maybe)
  const { filterKey, close } = props;
  const submissions = useSubmissions();
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
    new Set(submissions.map((curation) => curation[filterKey]))
  ) as string[];

  return (
    <div
      className="absolute z-10 h-64 w-64 mb-4 top-10 overflow-y-scroll p-2"
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

export const ArchiveTableRow = styled.tr`
  ${tw`bg-phlote-container text-white h-14 items-center py-4 `}

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;

export const ArchiveTableDataCell = styled.td`
  ${tw`bg-phlote-container text-white h-14 items-center`}

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;
