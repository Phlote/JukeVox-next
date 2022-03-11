import React from "react";
import { Footer } from "./Footer";
import { RinkebyPromptModal } from "./Modal";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export const HomeLayout: React.FC = ({ children }) => {
  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <SubmitSidenav />
      <RinkebyPromptModal />

      <NavBar />
      <div className="container flex justify-center mx-auto max-h-max items-center flex-grow">
        {children}
      </div>
      <Footer />
    </div>
  );
};

interface ArchiveLayoutProps {
  center?: boolean;
}

export const ArchiveLayout: React.FC<ArchiveLayoutProps> = ({
  children,
  center,
}) => {
  return (
    <div className="h-screen flex flex-col w-full overflow-y-auto">
      <SubmitSidenav />
      <RinkebyPromptModal />

      <NavBar />
      <div
        className="container flex justify-center mx-auto flex-grow"
        style={center ? { alignItems: "center", flexGrow: 1 } : undefined}
      >
        {children}
      </div>
    </div>
  );
};

export const ProfileLayout: React.FC = ({ children }) => {
  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <SubmitSidenav />
      <RinkebyPromptModal />

      <NavBar />
      <div className="container flex justify-center mx-auto max-h-max items-center flex-grow">
        {children}
      </div>
    </div>
  );
};
