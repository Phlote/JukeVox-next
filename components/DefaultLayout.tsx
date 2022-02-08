import React from "react";
import { SubmitSidenav } from "./SideNav";

export const DefaultLayout = ({ children }) => {
  return (
    <div className="h-screen flex flex-col w-full">
      <SubmitSidenav className="absolute bg-red" />
      {children}
    </div>
  );
};
