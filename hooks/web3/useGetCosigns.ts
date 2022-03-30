import { useQuery } from "react-query";
import { usePhlote } from "./usePhlote";

export const useGetCosigns = (editionId) => {
  const phlote = usePhlote();
  return useQuery(
    [editionId, "cosigns"],
    async () => await phlote.getCosigns(editionId)
  );
};
