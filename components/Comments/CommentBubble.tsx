import { useComments } from "../../hooks/useComments";
import CommentBubbleSVG from "../../public/comment_bubble.svg";

export const CommentBubble: React.FC = () => {
  const { count } = useComments();

  if (!count) return <></>;

  return (
    <div className="relative">
      <CommentBubbleSVG fill="white" />
      <p style={{ top: 5, left: 11.5 }} className="text-xs z-10 absolute ">
        {" "}
        {count}
      </p>
    </div>
  );
};
