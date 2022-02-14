import type { BigNumberish } from "@ethersproject/bignumber";
import { formatUnits } from "@ethersproject/units";
import { NETWORKS } from "./constants";

export function shortenHex(hex: string, length = 4) {
  return `${hex.substring(0, length + 2)}…${hex.substring(
    hex.length - length
  )}`;
}

const ETHERSCAN_PREFIXES = {
  1: "",
  3: "ropsten.",
  4: "rinkeby.",
  5: "goerli.",
  42: "kovan.",
};

export function formatEtherscanLink(
  type: "Account" | "Transaction",
  data: [number, string]
) {
  switch (type) {
    case "Account": {
      const [chainId, address] = data;
      return `https://${ETHERSCAN_PREFIXES[chainId]}etherscan.io/address/${address}`;
    }
    case "Transaction": {
      const [chainId, hash] = data;
      return `https://${ETHERSCAN_PREFIXES[chainId]}etherscan.io/tx/${hash}`;
    }
  }
}

export const parseBalance = (value: BigNumberish, decimals = 18) =>
  parseFloat(formatUnits(value, decimals));

export const balanceToString = (
  value: BigNumberish,
  decimals = 18,
  decimalsToDisplay = 3
) => parseBalance(value, decimals).toFixed(decimalsToDisplay);

export const changeNetwork = async (
  networkName: string,
  setError: (e: string) => void
) => {
  try {
    if (!window.ethereum) throw new Error("No crypto wallet found");
    // TODO: get a proper type here
    await (window.ethereum as any).request({
      method: "wallet_addEthereumChain",
      params: [
        {
          ...NETWORKS[networkName],
        },
      ],
    });
  } catch (err) {
    setError(err.message);
  }
};

export function nextApiRequest(
  path: string,
  method = "GET",
  data?: Record<string, any>
): Promise<Record<string, any>> {
  return fetch(`/api/${path}`, {
    method: method,
    headers: {
      "Content-Type": "application/json",
    },
    body: data ? JSON.stringify(data) : undefined,
  }).then((response) => response.json());
}
