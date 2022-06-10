import { useWeb3React } from "@web3-react/core";
import cn from "classnames";
import React from "react";
import { CommentType, useComments } from "../../hooks/useComments";
import { Heart } from "../../icons/Heart";
import { invokeVote } from "./VoteButtons";

const HeartButton = (): JSX.Element => {
  // const { user } = useUser();
  const { account } = useWeb3React();
  const { rootComment, mutateRootComment } = useComments();

  async function handleVote(): Promise<void> {
    // TODO open wallet connect modal here
    // if (!user) return open("signInModal");
    if (!rootComment || !rootComment.id) return;

    if (rootComment.userVoteValue === 0) {
      mutateRootComment(
        (data: CommentType) => ({
          ...data,
          votes: (rootComment.votes || 0) + 1,
          userVoteValue: 1,
        }),
        false
      );
      await invokeVote(rootComment.id, account, 1);
    } else {
      mutateRootComment(
        (data: CommentType) => ({
          ...data,
          votes: (rootComment.votes || 0) - 1,
          userVoteValue: 0,
        }),
        false
      );
      await invokeVote(rootComment.id, account, 0);
    }
  }

  return (
    <button
      className="flex items-center focus-ring p-1 text-gray-600 hover:text-gray-500 dark:text-gray-200 dark:hover:text-gray-50 text-sm"
      onClick={handleVote}
      aria-label={`Like comment by ${rootComment?.author.username}`}
    >
      <Heart
        className={cn("w-6 h-6 stroke-1.5", {
          "text-red-600 fill-current": rootComment?.userVoteValue === 1,
        })}
      />
      <span className="ml-1 tabular-nums min-w-[12px]">
        {rootComment ? rootComment.votes : `-`}
      </span>
    </button>
  );
};

export default HeartButton;
