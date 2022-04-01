import React from "react";
import { ToastContainer } from "react-toastify";
import { RinkebyPromptModal } from "./Modal";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export default function Layout({ children }) {
  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <SubmitSidenav />
      <RinkebyPromptModal />
      <NavBar />
      <ToastContainer position="bottom-right" autoClose={5000} />
      {children}
    </div>
  );
}

interface ArchiveLayoutProps {
  center?: boolean;
}

export const ArchiveLayout: React.FC<ArchiveLayoutProps> = ({
  children,
  center,
}) => {
  return (
    <div
      className="container flex justify-center mx-auto flex-grow"
      style={center ? { alignItems: "center", flexGrow: 1 } : undefined}
    >
      {children}
    </div>
  );
};
