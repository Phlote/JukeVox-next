import React from "react";
import { usePhlote } from "../hooks/web3/usePhlote";
import Image from "next/image";
import { useWeb3React } from "@web3-react/core";
import { BigNumber } from "ethers";

export const RatingsMeter: React.FC<{
  editionId: BigNumber;
  txnPending: boolean;
}> = (props) => {
  const { editionId, txnPending } = props;
  const [cosigns, setCosigns] = React.useState<(string | "pending" | null)[]>(
    []
  );

  const phlote = usePhlote();

  React.useEffect(() => {
    const getCosigns = async () => {
      const currentCosigns = await phlote.getCosigns(editionId);
      setCosigns(currentCosigns);
    };

    if (phlote && !txnPending) {
      getCosigns();

      phlote.on("*", (res) => {
        if (res.event === "EditionCosigned") {
          getCosigns();
        }
      });
    } else if (txnPending) {
      setCosigns(Array(5).fill("pending"));
    }

    return () => {
      phlote?.removeAllListeners();
    };
  }, [phlote, txnPending, editionId]);

  const onCosign = async () => {
    setCosigns([...cosigns, "pending"]);
    try {
      await phlote.cosign(editionId);
    } catch (e) {
      setCosigns((current) => current.slice(0, current.length - 1));
    }
  };

  return (
    <div className="flex gap-1 justify-center">
      {Array(5)
        .fill(null)
        .map((_, idx) => {
          if (idx > cosigns.length - 1) {
            return (
              <div
                onClick={onCosign}
                className="h-6 w-6 relative cursor-pointer"
              >
                <Image
                  src="/clear_diamond.png"
                  alt="cosign here"
                  layout="fill"
                />
              </div>
            );
          } else {
            if (cosigns[idx] === "pending") {
              return (
                <div className="h-6 w-6 opacity-25 relative">
                  <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
                </div>
              );
            } else {
              return (
                <div className="h-6 w-6 relative">
                  <Image src="/blue_diamond.png" alt="cosigned" layout="fill" />
                </div>
              );
            }
          }
        })}
    </div>
  );
};
