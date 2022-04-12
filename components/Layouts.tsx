import { ToastContainer } from "react-toastify";
import { ConnectWalletModal } from "./Modals/ConnectWalletModal";
import { NavBar } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export default function Layout({ children }) {
  return (
    <div className="min-h-screen flex flex-col w-full overflow-y-auto	">
      <SubmitSidenav />
      <ConnectWalletModal />
      <NavBar />
      <>
        {children}
        <ToastContainer
          position="top-right"
          autoClose={5000}
          hideProgressBar={false}
          newestOnTop={false}
          closeOnClick
          rtl={false}
          pauseOnFocusLoss
          draggable
          pauseOnHover
        />
      </>
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
      className="container flex justify-center mx-auto flex-grow"
      style={center ? { alignItems: "center", flexGrow: 1 } : undefined}
    >
      {children}
    </div>
  );
};
