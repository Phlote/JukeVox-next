import React, { ReactNode } from "react";

interface DropdownActions {
  top?: number;
  bottom?: number;
  children: ReactNode;
}

export const DropdownActions: React.FC<DropdownActions> = (props) => {
  const { children, top, bottom } = props;
  return (
    <div
      className={`bg-phlote-dropdown z-10 w-full mb-4`}
      style={{ top, bottom }}
    >
      <div className="grid grid-cols-1 w-full overflow-y-scroll">
        {children}
      </div>
    </div>
  );
};
