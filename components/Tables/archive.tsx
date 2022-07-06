import classNames from "classnames";
import dayjs from "dayjs";
import { BigNumber, ethers } from "ethers";
import Image from "next/image";
import React from "react";
import styled from "styled-components";
import tw from "twin.macro";
import { useOnClickOut } from "../../hooks/useOnClickOut";
import {
  useSearchFilters,
  useSubmissionSearch,
} from "../../hooks/useSubmissions";
import { DropdownChecklist } from "../Dropdowns/DropdownChecklist";
import { DropdownRatings, GemRow } from "../Dropdowns/DropdownRatings";
import { Username } from "../Username";

export const ArchiveTableHeader = (props) => {
  const [dropdownOpen, setDropdownOpen] = React.useState<boolean>(false);
  const { label, filterKey } = props;
  const ref = React.useRef();
  useOnClickOut(ref, () => setDropdownOpen(false));
  const [filters] = useSearchFilters();

  const isActiveFilter = !!filters[filterKey];

  const submissionsQuery = useSubmissionSearch();
  const submissions = submissionsQuery.data?.pages?.flatMap(
    (group) => group?.submissions
  );

  const options = Array.from(
    new Set(submissions?.map((submission) => submission[filterKey]))
  ) as string[];

  return (
    <th>
      <div className="w-full flex justify-center py-4">
        <div
          ref={ref}
          className={classNames(
            "flex items-center justify-center  relative px-1",
            {
              "rounded-full": isActiveFilter,
              "border-2": isActiveFilter,
              "border-white": isActiveFilter,
            }
          )}
        >
          {isActiveFilter ? (
            <ArchiveFilterLabel
              filterKey={filterKey}
              filter={filters[filterKey]}
            />
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
                  options={options}
                />
              )}
            </>
          )}
        </div>
      </div>
    </th>
  );
};

export const ArchiveFilterLabel: React.FC<{
  filterKey: string;
  filter: string | number;
}> = ({ filterKey, filter }) => {
  if (filterKey === "noOfCosigns") {
    return <GemRow length={filter as number} />;
  }

  const isAddress = ethers.utils.isAddress(filter as string);
  if (isAddress) return <Username wallet={filter as string} />;
  else return <span>{filter}</span>;
};

export const SubmissionDate: React.FC<{
  submissionTimestamp: BigNumber | number | string;
}> = ({ submissionTimestamp }) => {
  return <span>{submissionTimeToDate(submissionTimestamp)}</span>;
};

const submissionTimeToDate = (timeStamp: BigNumber | number | string) => {
  let time = timeStamp;
  if (timeStamp instanceof BigNumber) {
    time = timeStamp.toNumber();
  }

  const submissionDate = dayjs(time as number | string);
  if (!submissionDate.isValid()) throw "Invalid Date String";

  return submissionDate.format("YYYY-MM-DD");
};

export const ArchiveDropdown: React.FC<{
  label: string;
  filterKey: string;
  close: () => void;
  options: string[];
}> = (props) => {
  //TODO: grey out fields that are usually present but not in current results (this is a maybe)
  const { filterKey, close, options } = props;

  const [filters, setFilters] = useSearchFilters();

  const updateFilter = (val) => {
    setFilters((current) => {
      const updated = { ...current };
      if (updated[filterKey] === val) {
        delete updated[filterKey];
      } else updated[filterKey] = val;
      return updated;
    });
  };

  return (
    <div
      className="absolute z-10 h-72	 w-64 mb-4 top-10 overflow-y-scroll p-2 bg-black"
      style={{ backgroundColor: "rgba(0, 0, 0, 0.90)" }}
    >
      {filterKey === "noOfCosigns" ? (
        <DropdownRatings
          value={filters[filterKey]}
          onChange={updateFilter}
          close={close}
          max={5}
        />
      ) : (
        <DropdownChecklist
          value={filters[filterKey]}
          onChange={updateFilter}
          fields={options}
          close={close}
        />
      )}
    </div>
  );
};

export const ArchiveTableRow = styled.tr`
  ${tw`text-white h-14 items-center py-4 `}
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
