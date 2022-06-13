// import { useSignInModal } from '@lib/components/comments/SignInModal';

import { useWeb3React } from "@web3-react/core";
import cn from "classnames";
import cuid from "cuid";
import { useEffect, useRef, useState } from "react";
import { CommentType, useComments } from "../../hooks/useComments";
import { supabase } from "../../lib/supabase";
import autosize from "../../utils/autosize";
import punctuationRegex from "../../utils/regex/punctuationRegex";
import { useProfile } from "../Forms/ProfileSettingsForm";
import Avatar from "./Avatar";

interface Props {
  parentId?: number | null;
  autofocus?: boolean;
  handleResetCallback?: () => void;
  hideEarlyCallback?: () => void;
}

const NewCommentForm = ({
  parentId = null,
  autofocus = false,
  handleResetCallback,
  hideEarlyCallback,
}: Props): JSX.Element => {
  const [content, setContent] = useState<string>("");
  const textareaRef = useRef<HTMLTextAreaElement | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const { account } = useWeb3React();
  const profile = useProfile(account);
  const { mutateGlobalCount, rootId, mutateComments } = useComments();
  // const { open, isOpen } = useModal({
  //   signInModal: SignInModal,
  //   newUserModal: NewUserModal,
  // });

  // useEffect(() => {
  //   if (user && profile && (!profile.full_name || !profile.username)) {
  //     open("newUserModal");
  //   }
  //   // eslint-disable-next-line react-hooks/exhaustive-deps
  // }, [user, profile]);

  // useEffect(() => {
  //   if (!isOpen) {
  //     setIsLoading(false);
  //   }
  // }, [isOpen]);

  useEffect(() => {
    if (autofocus) {
      if (textareaRef && textareaRef.current) {
        textareaRef.current.focus();
      }
    }
  }, [autofocus]);

  function handleChange(e: React.ChangeEvent<HTMLTextAreaElement>): void {
    setContent(e.target.value);
    if (textareaRef?.current) {
      autosize(textareaRef.current);
    }
  }

  function handleReset(): void {
    setContent("");
    if (textareaRef && textareaRef.current) {
      textareaRef.current.style.height = "initial";
    }
    setIsLoading(false);
  }

  async function handleSubmit(): Promise<void> {
    setIsLoading(true);
    hideEarlyCallback?.();

    // if (!user) {
    //   return open("signInModal");
    // }

    // if (!profile) {
    //   return open("newUserModal");
    // }

    const postString = content
      .toString()
      .substring(0, 77)
      .replace(punctuationRegex, "")
      .replace(/(\r\n|\n|\r)/gm, "")
      .split(" ")
      .filter((str) => str !== "")
      .join("-")
      .toLowerCase();

    const slug = `${postString}-${cuid.slug()}`;

    const post = {
      authorId: account,
      content: content,
      parentId: parentId ?? rootId,
      slug,
    };

    mutateGlobalCount((count: number) => count + 1, false);

    mutateComments(async (pages: CommentType[]) => {
      const optimisticResponse: CommentType = {
        ...post,
        author: profile,
        highlight: true,
        live: false,
        createdAt: new Date().toISOString(),
        title: null,
        isPublished: false,
        votes: 0,
        upvotes: 0,
        downvotes: 0,
        userVoteValue: 0,
      } as unknown as CommentType;

      const newData = [optimisticResponse, ...pages];

      return newData;
    }, false);

    const { data, error } = await supabase.from("comments").insert([post]);

    if (error) {
      console.log(error);
    } else {
      mutateComments(async (staleResponses: CommentType[]) => {
        const newResponse = {
          ...data?.[0],
          author: profile,
          responses: [],
          responsesCount: 0,
          highlight: true,
          votes: 0,
          upvotes: 0,
          downvotes: 0,
          userVoteValue: 0,
        } as unknown as CommentType;

        const filteredResponses = staleResponses.filter(
          (response) => response.slug !== newResponse.slug
        );

        const newData = [[newResponse], ...filteredResponses];

        return newData;
      }, false);

      handleReset();
      handleResetCallback?.();
    }
  }

  return (
    <>
      <div className="flex flex-grow flex-col min-h-14">
        <div className="flex-grow flex items-center space-x-2">
          {/* {!user && (
            <button
              className="focus-ring"
              onClick={() => open("signInModal")}
              aria-label="Create new account"
            >
              <User className="text-gray-600 w-7 h-7" />
            </button>
          )} */}
          {profile && (
            <button
              className="focus-ring"
              aria-label="View profile information"
            >
              <Avatar profile={profile.data} />
              {/* <Smile className="w-7 h-7 text-gray-500 hover:text-gray-800 transition" /> */}
            </button>
          )}

          <label className="flex-grow flex items-center cursor-text select-none focus-within-ring min-h-14">
            <span className="sr-only">Enter a comment</span>
            <textarea
              className="block bg-transparent flex-grow leading-5 min-h-5 max-h-36 resize-none m-0 px-0 text-gray-800 dark:text-gray-200 placeholder-gray-500 dark:placeholder-gray-300 border-none overflow-auto text-sm transition-opacity disabled:opacity-50 focus:outline-none focus:shadow-none focus:ring-0"
              placeholder="Add a comment..."
              rows={1}
              value={content}
              onChange={handleChange}
              ref={textareaRef}
              disabled={isLoading}
            ></textarea>
          </label>

          <div className="h-full flex items-center justify-center w-12">
            <button
              className={cn(
                "text-indigo-500 dark:text-indigo-400 font-semibold px-2 text-sm h-full max-h-10 border border-transparent focus-ring",
                {
                  "cursor-not-allowed opacity-50":
                    content.length < 1 || isLoading,
                }
              )}
              disabled={content.length < 1}
              onClick={handleSubmit}
              aria-label="Submit new post"
            >
              Post
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default NewCommentForm;
