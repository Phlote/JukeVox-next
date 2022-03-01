import { useWeb3React } from "@web3-react/core";
import { useRouter } from "next/router";
import { useEffect } from "react";

const useOnWalletDisconnect = () => {
  const { active } = useWeb3React();
  const router = useRouter();
  useEffect(() => {
    if (!active && router.pathname !== "/") {
      router.replace("/");
    }
  }, [active]);
};

export default useOnWalletDisconnect;
