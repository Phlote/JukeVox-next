import React from "react";

interface DropdownList {
  fields: string[];
  selectedField: string;
  onSelect: (field: string) => void;
}

export const DropdownList: React.FC<DropdownList> = ({
  fields,
  selectedField,
  onSelect,
}) => {
  return (
    <div className="grid grid-cols-1 divide-y w-full">
      {fields.map((field) => (
        <div
          className="w-full h-14 flex justify-left items-center"
          key={field}
          onClick={() => onSelect(field)}
        >
          <div className="w-4" />
          <input
            type="checkbox"
            name={field}
            checked={selectedField === field}
          ></input>
          <div className="w-4" />
          <label className="text-xl" htmlFor={field}>
            {field}
          </label>
        </div>
      ))}
    </div>
  );
};
