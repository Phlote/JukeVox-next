import { atom, useAtom } from "jotai";
import { Submission } from "../lib/graphql/generated";

const searchFiltersAtom = atom<Partial<Submission>>({});
export const useSearchFilters = () => useAtom(searchFiltersAtom);
