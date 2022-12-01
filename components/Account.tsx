import Image from "next/image";
import { useRouter } from "next/router";
import { useEffect, useRef, useState } from "react";
import { useIsCurator } from "../hooks/useIsCurator";
import { useOnClickOut } from "../hooks/useOnClickOut";
import Hamburger from "../public/hamburger.svg";
import { DropdownActions } from "./Dropdowns/DropdownActions";
import { useConnectWalletModalOpen } from "./Modals/ConnectWalletModal";
import { shortenHex } from "../utils/web3";
import { useProfile } from "./Forms/ProfileSettingsForm";
import { useChain, useMoralis } from "react-moralis";

const Account = (props) => {
  const { account, isWeb3Enabled, isAuthenticated, enableWeb3, provider } = useMoralis();
  const { switchNetwork, chainId, chain } = useChain();


  useEffect(() => {
    if (isAuthenticated) {
      if (provider) {
        if (provider.constructor.name === 'WalletConnectProvider') {
          enableWeb3({ provider: 'walletconnect', chainId: 80001 }).then(e => {
            console.log('enableWeb3 using wallet connect');
          })
        } else {
          enableWeb3().then(e => {
            if (chainId !== '0x13881') { //TODO: Get this value from somewhere else
              console.log('enableWeb3 using Metamask');

              switchNetwork('0x13881').then(r => console.log(r));
            }
          })
        }
      }
    }
    /**
     * -> isAuthenticated means being authenticated to your moralis server (this can be via a metamask signature)
     * -> isWeb3Enabled means that you have access to the web3 address and can use web3 functionalities
     * Due to that, isAuthenticated can be true even if isWeb3Enabled is false.
     * On page refresh, isWeb3Enabled is false, therefore we must enable it if the user already authenticated again.
     */
  }, [isAuthenticated])

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

  if (!isWeb3Enabled) {
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
      <span>{shortenHex(account, 5)}</span>
      <div className="w-2" />
      <AccountDropdown
        dropdownOpen={dropdownOpen}
        setDropdownOpen={setDropdownOpen}
        wallet={account}
      />
    </div>
  );
};

const AccountDropdown = (props) => {
  const { logout } = useMoralis();

  const router = useRouter();

  const onClickHandler = () => {
    setDropdownOpen(!dropdownOpen);
  };

  const isCuratorQuery = useIsCurator();

  const { dropdownOpen, setDropdownOpen, wallet } = props;

  const profile = useProfile(wallet);

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
                logout()
                  .then((user) => {
                    localStorage.clear();
                    console.log("logged out user:", user);
                  })
                  .catch((error) => {
                    console.error(error);
                  });
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
            {profile?.data?.username && (
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
