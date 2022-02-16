import React from "react";

interface DropdownList {
  fields: string[];
  value: string;
  onChange: (field: string) => void;
  onFocus: () => void;
}

export const DropdownList: React.FC<DropdownList> = ({
  fields,
  value,
  onChange,
  onFocus,
}) => {
  React.useEffect(() => {
    return () => onFocus();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div className="grid grid-cols-1 divide-y w-full">
      {fields.map((field) => (
        <div
          className="w-full h-14 flex justify-left items-center"
          key={field}
          onClick={() => onChange(field)}
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
            {field}
          </label>
        </div>
      ))}
    </div>
  );
};
