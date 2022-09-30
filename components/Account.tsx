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
import { clearCachedConnector } from "../utils/web3";
import { LoginLens } from "./Modals/LoginLens";
import { LENSHUB_PROXY, DISPATCHER } from "../utils/constants";
import { LensHubProxy } from "../abis/LensHubProxy";
import { useContractWrite, useSignTypedData } from "wagmi";
import { omit } from "../lib/omit";
import { splitSignature } from "../lib/splitSignature";
import { toast } from "react-toastify";
import {
  enableDispatcherWithTypedData,
  disableDispatcherWithTypedData,
} from "../controllers/dispatcher";
import { getLensProfile } from "../utils/profile";

const Account = (props) => {
  const { active, error, activate, chainId, account, setError, deactivate } =
    useWeb3React();

  useEagerConnect();

  // manage connecting state for injected connector

  const [dropdownOpen, setDropdownOpen] = useState<boolean>(false);
  const [connectLens, setConnectLens] = useState<boolean>(false);
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
      {!connectLens ? (
        <LoginLens connectLens={connectLens} setConnectLens={setConnectLens} />
      ) : (
        <>
          <ShortenedWallet wallet={account} />
          <AccountDropdown
            dropdownOpen={dropdownOpen}
            setDropdownOpen={setDropdownOpen}
          />
        </>
      )}
    </div>
  );
};

const AccountDropdown = (props) => {
  const { deactivate } = useWeb3React();
  const { signTypedDataAsync } = useSignTypedData({
    onError(error) {
      toast.error(error?.message);
      //setTransactionLoading(false);
    },
  });
  const { data: dispatcherData, write: setDispathcer } = useContractWrite({
    addressOrName: LENSHUB_PROXY,
    contractInterface: LensHubProxy,
    functionName: "setDispatcherWithSig",
    mode: "recklesslyUnprepared",
    onSuccess() {
      //setTransactionLoading(false);
    },
    onError(error: any) {
      toast.error(error);
      //setTransactionLoading(false);
    },
  });

  const profile = getLensProfile();
  const router = useRouter();

  const onClickHandler = () => {
    setDropdownOpen(!dropdownOpen);
  };

  const enableDispatcher = async () => {
    try {
      const result = await enableDispatcherWithTypedData({
        profileId: profile.id,
        // if left empty, a deafult dispatcher by Lens is used. Not clear why a custom value is not allowed (canUseRelay remains sety to false)
        // dispatcher: DISPATCHER,
      });

      const typedData = result.typedData;

      const signature = await signTypedDataAsync({
        domain: omit(typedData?.domain, "__typename"),
        types: omit(typedData?.types, "__typename"),
        value: omit(typedData?.value, "__typename"),
      });
      const { v, r, s } = splitSignature(signature);
      const sig = { v, r, s, deadline: typedData.value.deadline };
      const inputStruct = {
        profileId: typedData.value.profileId,
        dispatcher: typedData.value.dispatcher,
        sig,
      };

      setDispathcer?.({ recklesslySetUnpreparedArgs: inputStruct });
    } catch (error) {
      toast.error(error);
    }
  };

  // doesn't work
  const disableDispatcher = async () => {
    try {
      const result = await disableDispatcherWithTypedData({
        profileId: props.profile.id,
        enable: false,
      });

      const typedData = result.typedData;

      const signature = await signTypedDataAsync({
        domain: omit(typedData?.domain, "__typename"),
        types: omit(typedData?.types, "__typename"),
        value: omit(typedData?.value, "__typename"),
      });
      const { v, r, s } = splitSignature(signature);
      const sig = { v, r, s, deadline: typedData.value.deadline };
      const inputStruct = {
        profileId: typedData.value.profileId,
        dispatcher: typedData.value.dispatcher,
        sig,
      };

      setDispathcer?.({ recklesslySetUnpreparedArgs: inputStruct });
    } catch (error) {
      toast.error(error);
    }
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
                clearCachedConnector();
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
            {!profile?.dispatcher?.canUseRelay ? (
              <div
                className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center"
                onClick={() => {
                  enableDispatcher();
                  setDropdownOpen(false);
                }}
              >
                Enable Dispatcher
                <div className="w-4" />
                <Image
                  src="/arrow.svg"
                  alt={"disconnect"}
                  height={24}
                  width={24}
                />
              </div>
            ) : (
              <div
                className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center"
                onClick={() => {
                  disableDispatcher();
                  setDropdownOpen(false);
                }}
              >
                Disable Dispatcher
                <div className="w-4" />
                <Image
                  src="/arrow.svg"
                  alt={"disconnect"}
                  height={24}
                  width={24}
                />
              </div>
            )}

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
