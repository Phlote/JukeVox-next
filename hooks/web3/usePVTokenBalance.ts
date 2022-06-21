import useSWR from "swr";
import type { PhloteVote } from "../../solidity/typechain";
import useKeepSWRDataLiveAsBlocksArrive from "./useKeepSWRDataLiveAsBlocksArrive";
import { usePhloteVote } from "./usePhloteVote";

function getTokenBalance(contract: PhloteVote) {
  return async (_: string, address: string) => {
    const balance = await contract.balanceOf(address);

    return balance;
  };
}

export default function usePVTokenBalance(
  address: string,
  tokenAddress: string,
  suspense = false
) {
  const contract = usePhloteVote();

  const shouldFetch =
    typeof address === "string" &&
    typeof tokenAddress === "string" &&
    !!contract;

  const result = useSWR(
    shouldFetch ? ["TokenBalance", address, tokenAddress] : null,
    getTokenBalance(contract),
    {
      suspense,
    }
  );

  useKeepSWRDataLiveAsBlocksArrive(result.mutate);

  return result;
}
