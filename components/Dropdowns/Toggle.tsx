import React, { useState } from "react";
import ToggleLib from 'react-toggle';
import "react-toggle/style.css";

interface DropdownChecklist {
  fields: string[];
  value?: string;
  onChange: (field: string) => void;
  onFocus?: () => void;
  closeOnSelect?: boolean;
  borders?: boolean;
  setFileSelected: () => void;
  setURI: (field: any) => void;
}

export const Toggle: React.FC<DropdownChecklist> = ({
  fields,
  value,
  onChange,
  onFocus,
  closeOnSelect = false,
  borders = false,
  setFileSelected,
  setURI
}) => {
  const [state, setState] = useState(false);

  const clearFields = () => {
    setFileSelected(); // Clear file selection when toggling
    setURI(null);
  }

  const toggle = () => {
    clearFields();
    state ? onChange(fields[0]) : onChange(fields[1]);
    setState(!state);
  }

  React.useEffect(() => {
    return () => {
      if (onFocus) onFocus();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <label className="flex space-x-1">
      <span>{state ? fields[1] : fields[0]}</span>
      <ToggleLib
        defaultChecked={state}
        onChange={toggle}
        icons={false}
      />
    </label>
  )
};
