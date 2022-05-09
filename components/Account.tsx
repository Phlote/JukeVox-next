import { useWeb3React } from "@web3-react/core";
import Image from "next/image";
import { useRouter } from "next/router";
import { useRef, useState } from "react";
import { useIsCurator } from "../hooks/useIsCurator";
import { useOnClickOut } from "../hooks/useOnClickOut";
import useEagerConnect from "../hooks/web3/useEagerConnect";
import Hamburger from "../public/hamburger.svg";
import { DropdownActions } from "./Dropdowns/DropdownActions";
import { useConnectWalletModalOpen } from "./Modals/ConnectWalletModal";
import { ShortenedWallet } from "./ShortenedWallet";

const Account = (props) => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();

  useEagerConnect();

  // manage connecting state for injected connector

  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const [, setOpen] = useConnectWalletModalOpen();

  const ref = useRef();
  useOnClickOut(ref, () => setDropdownOpen(false));

  // need to do something more intelligent here
  // if (error) {
  //   return (
  //     <HollowInputContainer
  //       className="h-full cursor-pointer"
  //       style={{ justifyContent: "center" }}
  //     >
  //       Check Wallet
  //     </HollowInputContainer>
  //   );
  // }

  if (typeof account !== "string") {
    return (
      <div className="w-full h-full text-center" onClick={() => setOpen(true)}>
        Connect
      </div>
    );
  }

  return (
    <div
      ref={ref}
      className="h-full w-full text-center flex flex-row"
      style={{ justifyContent: "center" }}
    >
      <ShortenedWallet wallet={account} />
      <div className="w-2" />
      <AccountDropdown
        dropdownOpen={dropdownOpen}
        setDropdownOpen={setDropdownOpen}
      />
    </div>
  );
};

const AccountDropdown = (props) => {
  const { deactivate } = useWeb3React();

  const router = useRouter();

  const onClickHandler = () => {
    setDropdownOpen(!dropdownOpen);
  };

  const isCuratorQuery = useIsCurator();

  const { dropdownOpen, setDropdownOpen } = props;
  return (
    <>
      <div className="hidden sm:block" onClick={onClickHandler}>
        <Image
          className={dropdownOpen ? "-rotate-90" : "rotate-90"}
          src={"/chevron.svg"}
          alt="dropdown"
          height={16}
          width={16}
        />
      </div>

      <div className="block sm:hidden" onClick={onClickHandler}>
        <Hamburger fill="white" height={24} width={24} />
      </div>

      {dropdownOpen && (
        <div className="absolute sm:top-14 bottom-16 z-20">
          <DropdownActions>
            <div
              className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center"
              onClick={() => {
                deactivate();
                setDropdownOpen(false);
              }}
            >
              Disconnect
              <div className="w-4" />
              <Image
                src="/exit.svg"
                alt={"disconnect"}
                height={24}
                width={24}
              />
            </div>
            {isCuratorQuery?.data?.isCurator && (
              <>
                <div className="w-4" />
                <div
                  onClick={() => {
                    router.push("/editprofile");
                    setDropdownOpen(false);
                  }}
                >
                  <div className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center">
                    Edit Profile
                  </div>
                </div>
              </>
            )}

            <div className="w-4" />
          </DropdownActions>
        </div>
      )}
    </>
  );
};

export default Account;
