import React from "react";
import { useComments } from "../../hooks/useComments";

function MessageBubble(props) {
  return (
    <svg
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth={1.5}
      fill="none"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      <path d="M1 10.944a9.311 9.311 0 001 4.223 9.445 9.445 0 008.444 5.222 9.312 9.312 0 004.223-1L21 21.5l-2.111-6.333a9.312 9.312 0 001-4.223A9.445 9.445 0 0014.667 2.5a9.311 9.311 0 00-4.223-1H9.89A9.422 9.422 0 001 10.389v.555z" />
    </svg>
  );
}

const MessageBubbleButton = (): JSX.Element => {
  const { count } = useComments();
  return (
    <button className="block focus-within-ring" aria-label="View comments">
      <a
        href="#comments"
        className="p-1 flex items-center transition-color text-gray-600 hover:text-gray-500 dark:text-gray-200 dark:hover:text-gray-50 text-sm"
      >
        <MessageBubble className="w-6 h-6" />
        <span className="ml-1">{count ? count : `-`}</span>
      </a>
    </button>
  );
};

export default MessageBubbleButton;
