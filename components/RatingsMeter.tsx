import { BigNumber } from "ethers";
import Image from "next/image";
import React, { useEffect } from "react";
import { useQueryClient } from "react-query";
import { useIsCurator } from "../hooks/useIsCurator";
import { useGetCosigns } from "../hooks/web3/useGetCosigns";
import { usePhlote } from "../hooks/web3/usePhlote";

export const RatingsMeter: React.FC<{
  editionId: BigNumber;
  txnPending: boolean;
}> = (props) => {
  const { editionId, txnPending } = props;
  const [gems, setGems] = React.useState<(string | "pending" | null)[]>([]);

  const { data, isLoading } = useGetCosigns(editionId);
  const queryClient = useQueryClient();

  const phlote = usePhlote();
  const isCurator = useIsCurator();

  const canCosign = isCurator && !gems.includes("pending");

  useEffect(() => {
    if (phlote && !txnPending) {
      phlote.on("*", (res) => {
        if (res.event === "EditionCosigned") {
          queryClient.invalidateQueries(["cosigns", editionId]);
        }
      });
    } else if (txnPending) {
      setGems(Array(5).fill("pending"));
    }

    return () => {
      phlote?.removeAllListeners();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [phlote, txnPending, editionId]);

  useEffect(() => {
    if (data) setGems(data);
  }, [data]);

  const onCosign = async () => {
    setGems([...gems, "pending"]);
    try {
      await phlote.cosign(editionId);
    } catch (e) {
      setGems((current) => current.slice(0, current.length - 1));
    }
  };

  return (
    <div
      className={`flex gap-1 justify-center ${
        canCosign ? "hover:opacity-25 cursor-pointer" : undefined
      }`}
    >
      {Array(5)
        .fill(null)
        .map((_, idx) => {
          if (idx > gems.length - 1) {
            return (
              <button
                onClick={onCosign}
                className={"h-6 w-6 relative"}
                disabled={!canCosign}
              >
                <Image
                  src="/clear_diamond.png"
                  alt="cosign here"
                  layout="fill"
                />
              </button>
            );
          } else {
            if (gems[idx] === "pending") {
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
