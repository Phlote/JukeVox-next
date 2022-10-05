import type { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import useETHBalance from "../hooks/web3/useETHBalance";
import { balanceToString } from "../utils/web3";
import { useMoralis } from "react-moralis";

// UNUSED

const ETHBalance = () => {
  const { account } = useMoralis();
  const { data } = useETHBalance(account);

  return <p>Balance: Ξ{balanceToString(data ?? 0)}</p>;
};

export default ETHBalance;
