import React from "react";
import { usePhlote } from "../hooks/web3/usePhlote";

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
        console.log(res);
        if (res.event === "EditionCosigned") {
          console.log(res);
          setCosigns([...cosigns, res.args[0]]);
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

  const onCosign = () => {
    setCosigns([...cosigns, "pending"]);
    phlote.cosign(editionId);
  };

  return (
    <div className="flex">
      {Array(5)
        .fill(null)
        .map((_, idx) => {
          if (idx > cosigns.length - 1) {
            return <div onClick={onCosign}> Cosign here!</div>;
          } else {
            if (cosigns[idx] === "pending") {
              return <div> Pending </div>;
            } else {
              return <div>Cosigned </div>;
            }
          }
        })}
    </div>
  );
};
