import type { BigNumberish } from "@ethersproject/bignumber";
import { formatUnits } from "@ethersproject/units";
import { nextApiRequest } from ".";
import { UserNonce } from "../types";
import { NETWORKS, PHLOTE_SIGNATURE_REQUEST_MESSAGE } from "./constants";

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

// determines if the holder of an address actually holds the wallet
export const verifyUser = async (address: string, library) => {
  //TODO: should have a controller so we have better typing here
  const user = (await nextApiRequest(
    `auth?address=${address}`,
    "GET"
  )) as UserNonce;
  const signer = library.getSigner();
  const signature = await signer.signMessage(
    PHLOTE_SIGNATURE_REQUEST_MESSAGE + user.nonce.toString()
  );
  const { authenticated } = (await nextApiRequest(
    `confirm?wallet=${address}&signature=${signature}`,
    "GET"
  )) as { authenticated: boolean };
  return authenticated;
};
