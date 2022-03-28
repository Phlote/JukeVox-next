import Image from "next/image";
import React from "react";
import { useIsCurator } from "../hooks/useIsCurator";
import { usePhlote } from "../hooks/web3/usePhlote";

export const RatingsMeter: React.FC<{
  editionId: number;
}> = (props) => {
  const { editionId } = props;
  const [cosigns, setCosigns] = React.useState<(string | "pending" | null)[]>(
    []
  );

  const phlote = usePhlote();
  const isCurator = useIsCurator();

  React.useEffect(() => {
    const getCosigns = async () => {
      const currentCosigns = await phlote.getCosigns(editionId);
      setCosigns(currentCosigns);
    };

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
  }, [phlote, editionId]);

  const onCosign = async () => {
    setCosigns([...cosigns, "pending"]);
    try {
      await phlote.cosign(editionId);
    } catch (e) {
      setCosigns((current) => current.slice(0, current.length - 1));
    }
  };

  return (
    <div
      className="flex gap-1 justify-center"
      style={!isCurator ? { opacity: "25%" } : undefined}
    >
      {Array(5)
        .fill(null)
        .map((_, idx) => {
          if (idx > cosigns.length - 1) {
            return (
              <button
                onClick={onCosign}
                className="h-6 w-6 relative"
                style={isCurator ? { cursor: "pointer" } : undefined}
                disabled={!isCurator}
              >
                <Image
                  src="/clear_diamond.png"
                  alt="cosign here"
                  layout="fill"
                />
              </button>
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
