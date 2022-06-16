import { useWeb3React } from "@web3-react/core";
import { arrayToTree } from "performant-array-to-tree";
import { createContext, useContext, useState } from "react";
import useSWR, { useSWRInfinite } from "swr";
import { UserProfile } from "../components/Forms/ProfileSettingsForm";
import { supabase } from "../lib/supabase";

const PAGE_SIZE = 10;

export interface CommentType {
  id: number;
  slug: string;
  title: string;
  content: string;
  authorId: string;
  parentId: number;
  createdAt: string;
  isPublished: boolean;
  updatedAt: string;
  author: UserProfile;
  isPinned: boolean;
  responsesCount: number;
  responses: CommentType[];
  parent?: CommentType;
  live: boolean;
  depth: number;
  justAuthored?: boolean;
  continueThread?: boolean;
  highlight?: boolean;
  isDeleted: boolean;
  isApproved: boolean;
  totalChildrenCount?: number;
  pageIndex?: number;
  path: number[];
  votes: number;
  upvotes: number;
  downvotes: number;
  userVoteValue: number;
  pathVotesRecent: number[];
  pathLeastRecent: number[];
  pathMostRecent: number[];
}

export type SortingBehavior =
  | "pathVotesRecent"
  | "pathLeastRecent"
  | "pathMostRecent";

interface CommentsContextInterface {
  commentId: number | null;
  account: string | null;
  rootComment: CommentType | null | undefined;
  comments: CommentType[];
  rootId: number | null;
  count: number | null | undefined;
  remainingCount: number | null;
  error: any;
  commentsError: any;
  isLoadingInitialData: boolean;
  isLoadingMore: boolean;
  isEmpty: boolean;
  isReachingEnd: boolean | undefined;
  loadMore: () => void;
  mutateComments: any;
  mutateGlobalCount: any;
  mutateRootComment: any;
  sortingBehavior: SortingBehavior;
  setSortingBehavior: (behavior: SortingBehavior) => void;
  setSize: (
    size: number | ((size: number) => number)
  ) => Promise<any[] | undefined | null> | null;
}

const CommentsContext = createContext<CommentsContextInterface>({
  commentId: null,
  account: null,
  rootComment: null,
  comments: [],
  rootId: null,
  count: null,
  remainingCount: null,
  error: null,
  commentsError: null,
  isLoadingInitialData: false,
  isLoadingMore: false,
  isEmpty: true,
  isReachingEnd: true,
  loadMore: () => {
    return;
  },
  mutateComments: null,
  mutateGlobalCount: null,
  mutateRootComment: null,
  sortingBehavior: "pathVotesRecent",
  setSortingBehavior: () => {
    return;
  },
  setSize: () => {
    return null;
  },
});

interface CommentsContextProviderProps {
  commentId: number | null;
  [propName: string]: any;
}

const postgresArray = (arr: any[]): string => `{${arr.join(",")}}`;

export const CommentsContextProvider = (
  props: CommentsContextProviderProps
): JSX.Element => {
  const { commentId } = props;
  const { account } = useWeb3React();
  const [sortingBehavior, setSortingBehavior] =
    useState<SortingBehavior>("pathVotesRecent");

  const {
    data: count,
    mutate: mutateGlobalCount,
    error: commentsError,
  } = useSWR<number | null, any>(`globalCount_${commentId}`, {
    initialData: null,
    fetcher: () => null,
    revalidateOnFocus: false,
    revalidateOnMount: false,
  });

  const { data: rootComment, mutate: mutateRootComment } = useSWR(
    ["comments", commentId, account],
    async (_, commentId, _user) =>
      supabase
        .from("comments_thread_with_user_vote")
        .select("*")
        .eq("id", commentId)
        .then(({ data, error }) => {
          if (error) {
            console.log(error);
            throw error;
          }

          if (!data?.[0]) return null;

          return data[0] as unknown as CommentType;
        })
  );

  const getKey = (
    pageIndex: number,
    previousPageData: CommentType[],
    commentId: number | null,
    sortingBehavior: SortingBehavior,
    account: string | null
  ): [string, string, SortingBehavior, string | null] | null => {
    if (!commentId) return null;
    if (previousPageData && !previousPageData.length) return null;
    if (pageIndex === 0) {
      return [
        "comments_thread_with_user_vote",
        postgresArray([commentId]),
        sortingBehavior,
        account,
      ];
    }

    return [
      "comments_thread_with_user_vote",
      postgresArray(
        previousPageData[previousPageData.length - 1][sortingBehavior]
      ),
      sortingBehavior,
      account,
    ];
  };

  const {
    data,
    error,
    size,
    setSize,
    mutate: mutateComments,
  } = useSWRInfinite(
    (pageIndex, previousPageData) =>
      getKey(pageIndex, previousPageData, commentId, sortingBehavior, account), // Include user to revalidate when auth changes
    async (_name, path, sortingBehavior, _user) => {
      return (
        supabase
          .from("comments_thread_with_user_vote")
          .select("*", { count: "exact" })
          .contains("path", [commentId])
          // .lt('depth', MAX_DEPTH)
          .gt(sortingBehavior, path)
          .order(sortingBehavior as any)
          .limit(PAGE_SIZE)
          .then(({ data, error, count: tableCount }) => {
            if (error) throw error;
            if (!data) return null;
            mutateGlobalCount((count) => {
              if (count) return count;
              return tableCount;
            }, false);

            return data;
          })
      );
    },
    {
      revalidateOnFocus: false,
      // revalidateOnMount: !cache.has(['comments_thread_with_user_vote', postgresArray([postId])]),
    }
  );

  const flattenedComments: CommentType[] = data ? data.flat() : [];

  const rootParentIds = flattenedComments
    .filter((comment: CommentType) => comment.parentId === commentId)
    .map((comment: CommentType) => comment.parentId)
    .reduce(
      (accumulator, currentValue) => ({
        ...accumulator,
        [currentValue]: true,
      }),
      {}
    );

  const comments: CommentType[] = data
    ? (arrayToTree(flattenedComments, {
        dataField: null,
        childrenField: "responses",
        rootParentIds,
      }) as CommentType[])
    : [];
  const isLoadingInitialData = !data && !error;
  const isLoadingMore =
    isLoadingInitialData ||
    !!(size > 0 && data && typeof data[size - 1] === "undefined");
  const isEmpty = !data || data?.[0]?.length === 0;
  const remainingCount =
    !count || isEmpty ? 0 : count - flattenedComments.length;
  const isReachingEnd =
    isEmpty || (data && data[data.length - 1]?.length < PAGE_SIZE);

  function loadMore(): void {
    if (isLoadingMore || isReachingEnd) return;
    setSize(size + 1);
  }

  const value = {
    commentId,
    account,
    comments,
    rootComment,
    commentsError,
    rootId: commentId,
    count,
    remainingCount,
    error,
    isLoadingInitialData,
    isLoadingMore,
    isEmpty,
    isReachingEnd,
    loadMore,
    mutateComments,
    mutateGlobalCount,
    mutateRootComment,
    sortingBehavior,
    setSortingBehavior,
    setSize,
  };

  return <CommentsContext.Provider value={value} {...props} />;
};

export function useComments(): CommentsContextInterface {
  const context = useContext(CommentsContext);

  if (context === undefined) {
    throw new Error(
      `useComments must be used within a CommentsContextProvider.`
    );
  }

  return context;
}
