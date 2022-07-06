import classNames from "classnames";
import Image from "next/image";
import React from "react";

interface DropdownRatings {
  max: number;
  close: () => void;
  value?: number;
  onChange: (field: number) => void;
  onFocus?: () => void;
  closeOnSelect?: boolean;
  borders?: boolean;
}

export const DropdownRatings: React.FC<DropdownRatings> = ({
  max,
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
      className={classNames("grid grid-cols-1 w-full h-full", {
        "divide-y": borders,
      })}
    >
      {[...Array(max + 1).keys()].slice(1).map((gems) => {
        return (
          <div
            className="w-full sm:h-14 h-12 flex justify-left items-center"
            key={gems}
            onClick={() => {
              onChange(gems);
              if (closeOnSelect) close();
            }}
          >
            <div className="w-4" />
            <input
              type="checkbox"
              readOnly
              name={gems.toString()}
              checked={value === gems}
            ></input>
            <div className="w-4" />

            <GemRow length={gems} />
          </div>
        );
      })}
    </div>
  );
};

export const GemRow = ({ length }) => {
  return (
    <div className="flex gap-1">
      {Array(length)
        .fill(null)
        .map((_, idx) => {
          return (
            <div className="h-6 w-6 relative" key={idx}>
              <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
            </div>
          );
        })}
    </div>
  );
};
