import React from "react";

interface DropdownList {
  fields: string[];
}

export const DropdownList: React.FC<DropdownList> = ({ fields }) => {
  return (
    <div className="grid grid-cols-1 divide-y w-full">
      {fields.map((field) => (
        <div className="w-full h-14 flex justify-left items-center" key={field}>
          <div className="w-4" />
          <input type="checkbox" name={field}></input>
          <div className="w-4" />
          <label className="text-xl" htmlFor={field}>
            {field}
          </label>
        </div>
      ))}
    </div>
  );
};
