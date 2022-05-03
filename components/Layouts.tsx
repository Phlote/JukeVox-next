import styled from "styled-components";
import { ConnectWalletModal } from "./Modals/ConnectWalletModal";
import { MobileSubmissionModal } from "./Modals/MobileSubmissionModal";
import { NavBarDesktop, NavBarMobileWeb } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export default function Layout({ children }) {
  return (
    <div className="absolute inset-0">
      <div className="h-full flex flex-col w-full overflow-y-auto overflow-x-hidden relative">
        <BackgroundWithBlurs />
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

export const BackgroundWithBlurs = () => {
  return (
    <>
      <Blob1 />
      <Ellipse1 />
      <Ellipse2 />
    </>
  );
};

const Blob1 = styled.div`
  position: absolute;
  left: 74.38%;
  right: -32.43%;
  top: 46%;
  bottom: 0%;

  background: #ffffff;
  opacity: 0.15;
  filter: blur(300px);
  transform: matrix(-1, 0, 0, 1, 0, 0);
`;

const Ellipse1 = styled.div`
  position: absolute;
  left: 54.97%;
  right: -35.4%;
  top: 92.76%;
  bottom: -91.38%;

  background: #ffffff;
  opacity: 0.15;
  filter: blur(300px);
  transform: matrix(-0.7, -0.71, -0.71, 0.7, 0, 0);
`;

const Ellipse2 = styled.div`
  position: absolute;
  left: 30.42%;
  right: 23.6%;
  top: 4.66%;
  bottom: 1.01%;

  background: #ffffff;
  opacity: 0.15;
  filter: blur(300px);
  transform: rotate(-45deg);
`;

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
