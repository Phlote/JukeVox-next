import type { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
//import useTokenBalance from "../hooks/web3/useTokenBalance";
import { balanceToString } from "../utils/web3";

// UNUSED

type TokenBalanceProps = {
  tokenAddress: string;
  symbol: string;
};

const TokenBalance = ({ tokenAddress, symbol }: TokenBalanceProps) => {
  const { account } = useWeb3React<Web3Provider>();
  // const { data } = useTokenBalance(account, tokenAddress);

  return (
    <p>
      {/* {`${symbol} Balance`}: {balanceToString(data ?? 0)} */}
    </p>
  );
};

export default TokenBalance;
