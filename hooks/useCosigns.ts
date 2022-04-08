import { useQuery } from "react-query";
import { supabase } from "../lib/supabase";

export const useCosigns = (submissionId: number) => {
  const getCosigns = async (): Promise<string[]> => {
    const query = await supabase
      .from("cosigns")
      .select()
      .match({ submissionId });
    if (query.data && query.data.length > 0) {
      return query.data[0].cosigns;
    } else return [];
  };

  return useQuery(["cosigns", submissionId], getCosigns);
};
