import { useQuery } from "@apollo/client";
import { atom, useAtom } from "jotai";
import {
  GetSubmissionsDocument,
  Submission_Filter,
} from "../lib/graphql/generated";

const searchFiltersAtom = atom<Submission_Filter>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);

export const useSubmissionsWithFilter = () => {
  const [filter] = useSearchFilters();

  const submissionsQuery = useQuery(GetSubmissionsDocument, {
    variables: { filter },
  });
  return submissionsQuery?.data?.submissions;
};
