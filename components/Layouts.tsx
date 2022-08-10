import { useEffect, useState } from "react";
import styled from "styled-components";
import { ConnectWalletModal } from "./Modals/ConnectWalletModal";
import { MobileSubmissionModal } from "./Modals/MobileSubmissionModal";
import { NavBarDesktop, NavBarMobileWeb } from "./NavBar";
import { SubmitSidenav } from "./SideNav";

export default function Layout({ children }) {
  return (
    <div className="absolute inset-0">
      <BackgroundWithBlurs />
      <div className="hidden sm:block">
        <SubmitSidenav />
      </div>
      <div className="sm:hidden block">
        <MobileSubmissionModal />
      </div>
      <ConnectWalletModal />
      <div className="hidden sm:block">
        <NavBarDesktop />
      </div>
      {children}
    </div>
  );
}

export const BackgroundWithBlurs = () => {
  const [isFirefox, setIsFirefox] = useState(false);

  useEffect(() => {
    setIsFirefox(window.navigator.userAgent.indexOf("Firefox") > -1);
  }, []);

  return (
    <div className="-z-50 fixed h-screen w-screen left-0 right-0">
      { isFirefox ? <FFGradient/> :
        <>
          <Blob1/>
          <Ellipse1/>
          <Ellipse2/>
        </> }
    </div>
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

const FFGradient = styled.div`
  position: absolute;
  width: 200%;
  height: 200%;

  background: radial-gradient(
    circle,
    rgba(255, 255, 255, 0.15) 0%,
    rgba(255, 255, 255, 0.15) 5%,
    rgba(0, 0, 0, 0) 100%
  );
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
      className="container flex justify-center mx-auto h-full pb-8 mt-32"
      style={center ? { alignItems: "center", flexGrow: 1 } : undefined}
    >
      <div className="mx-4">{children}</div>
    </div>
  );
};
