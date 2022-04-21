import { ConnectWalletModal } from "./Modals/ConnectWalletModal";
import { MobileSubmissionModal } from "./Modals/MobileSubmissionModal";
import { NavBarDesktop, NavBarMobileWeb } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export default function Layout({ children }) {
  return (
    <div className="absolute inset-0">
      <div className="h-screen flex flex-col w-full overflow-y-auto overflow-x-hidden">
        <div className="hidden sm:block">
          <SubmitSidenav />
        </div>
        <div className="sm:hidden block">
          <MobileSubmissionModal />
        </div>
        <ConnectWalletModal />
        <div className="hidden sm:flex">
          <NavBarDesktop />
        </div>
        {children}
        <div className="sm:hidden ">
          <NavBarMobileWeb />
        </div>
      </div>
    </div>
  );
}

interface ArchiveLayoutProps {
  center?: boolean;
  children: React.ReactNode;
}

export const ArchiveLayout: React.FC<ArchiveLayoutProps> = ({
  children,
  center,
}) => {
  return (
    <div
      className="container flex justify-center mx-auto flex-grow pb-8"
      style={center ? { alignItems: "center", flexGrow: 1 } : undefined}
    >
      {children}
    </div>
  );
};
