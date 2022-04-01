import { useRef } from "react";
import { useOnCopy } from "../hooks/useOnCopy";
import useENSName from "../hooks/web3/useENSName";
import { shortenHex } from "../utils/web3";

export const ShortenedWallet: React.FC<{ wallet: string }> = ({ wallet }) => {
  const ENSName = useENSName(wallet);
  const ref = useRef();
  useOnCopy(ref, wallet);
  return <span ref={ref}>{ENSName || `${shortenHex(wallet, 5)}`}</span>;
};
