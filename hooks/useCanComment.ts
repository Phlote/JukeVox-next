import { useRouter } from "next/router";
import React from "react";
import { supabase } from "../lib/supabase";
import { useIsCurator } from "./useIsCurator";
import { useMoralis } from "react-moralis";

export const useCanComment = (submissionWallet) => {
  const router = useRouter();
  const isCurator = useIsCurator();
  const { account } = useMoralis();

  if (!router.pathname.includes("submission")) {
    throw "this shouldn't be called in a different page";
  }

  return isCurator?.data?.isCurator || submissionWallet === account;
};
