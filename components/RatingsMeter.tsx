import React from "react";
import { usePhlote } from "../hooks/web3/usePhlote";

export const RatingsMeter = (props) => {
  const { editionId } = props;
  const [cosigns, setCosigns] = React.useState<(string | "pending" | null)[]>();

  const phlote = usePhlote();

  React.useEffect(() => {
    if (phlote) {
      phlote.on("*", (res) => {
        console.log(res);
        if (res.event === "EditionCosigned") {
        }
      });
    }

    return () => {
      phlote?.removeAllListeners();
    };
  }, [phlote]);

  return (
    <div className="flex">
      {/* {cosigns.map((cosign) => {
        if (cosign) {
          if (cosign !== "pending") return <div>Cosigned!</div>;
          else return <div>Pending Blockchain</div>;
        }
      })} */}
    </div>
  );
};
