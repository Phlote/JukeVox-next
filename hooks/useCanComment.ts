import { useWeb3React } from "@web3-react/core";
import { useRouter } from "next/router";
import React from "react";
import { supabase } from "../lib/supabase";
import { useIsCurator } from "./useIsCurator";
import { useMoralis } from "react-moralis";

export const useCanComment = () => {
  const router = useRouter();
  const isCurator = useIsCurator();
  const { account } = useMoralis();

  if (!router.pathname.includes("submission")) {
    throw "this shouldn't be called in a different page";
  }
  const { id } = router.query;

  const [wallet, setWallet] = React.useState<string>(null);
  React.useEffect(() => {
    const getWallet = async () => {
      const res = await supabase
        .from("submissions")
        .select()
        .match({ id: id.toString() });

      setWallet(res.data[0].curatorWallet);
    };
    getWallet();
  }, [id]);

  return isCurator?.data?.isCurator || wallet === account;
};
