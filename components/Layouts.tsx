import { ConnectWalletModal } from "./Modals/ConnectWalletModal";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export default function Layout({ children }) {
  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <SubmitSidenav />
      <ConnectWalletModal />
      <NavBar />

      {children}
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
