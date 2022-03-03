import React from "react";
import { usePhlote } from "../hooks/web3/usePhlote";
import Image from "next/image";
import { useWeb3React } from "@web3-react/core";

export const RatingsMeter = (props) => {
  const { editionId } = props;
  const [cosigns, setCosigns] = React.useState<(string | "pending" | null)[]>(
    []
  );

  const phlote = usePhlote();

  React.useEffect(() => {
    if (phlote) {
      getCosigns();

      phlote.on("*", (res) => {
        if (res.event === "EditionCosigned") {
          getCosigns();
        }
      });
    }

    return () => {
      phlote?.removeAllListeners();
    };
  }, [phlote]);

  const getCosigns = async () => {
    console.log("getCosigns");
    const currentCosigns = await phlote.getCosigns(editionId);
    setCosigns(currentCosigns);
  };

  const onCosign = async () => {
    setCosigns([...cosigns, "pending"]);
    try {
      await phlote.cosign(editionId);
    } catch (e) {
      console.log("here");
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
              <div onClick={onCosign} className="h-6 w-6 relative">
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
