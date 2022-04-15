import classNames from "classnames";
import { ethers } from "ethers";
import React from "react";
import { ShortenedWallet } from "../ShortenedWallet";

interface DropdownChecklist {
  fields: string[];
  close: () => void;
  value?: string;
  onChange: (field: string) => void;
  onFocus?: () => void;
  closeOnSelect?: boolean;
  borders?: boolean;
}

export const DropdownChecklist: React.FC<DropdownChecklist> = ({
  fields,
  close,
  value,
  onChange,
  onFocus,
  closeOnSelect = false,
  borders = false,
}) => {
  React.useEffect(() => {
    return () => {
      if (onFocus) onFocus();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div
      className={classNames("grid grid-cols-1 w-full overflow-y-scroll", {
        "divide-y": borders,
      })}
    >
      {fields.map((field) => {
        const isAddress = ethers.utils.isAddress(field);
        return (
          <div
            className="w-full h-14 flex justify-left items-center"
            key={field}
            onClick={() => {
              onChange(field);
              if (closeOnSelect) close();
            }}
          >
            <div className="w-4" />
            <input
              type="checkbox"
              readOnly
              name={field}
              checked={value === field}
            ></input>
            <div className="w-4" />
            <label className="text-xl" htmlFor={field}>
              {isAddress ? <ShortenedWallet wallet={field} /> : field}
            </label>
          </div>
        );
      })}
    </div>
  );
};
