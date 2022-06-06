import throttle from "lodash.throttle";
import React from "react";

export const useOnScrollToBottom = (
  onBottom: () => Promise<any>,
  enabled = true,
  buffer = 100
) => {
  const scrollAreaRef = React.useRef(null);

  const onScroll = async (ref) => {
    if (!ref.current) return;
    const { scrollHeight, scrollTop, clientHeight } = ref.current;

    // See if scroll is close enough to bottom to warrant loading more. 100px default buffer added
    if (scrollHeight - Math.abs(scrollTop) < clientHeight + buffer) {
      await onBottom();
    }
  };

  const throttledOnScroll = throttle(() => onScroll(scrollAreaRef), 20);

  React.useEffect(() => {
    const scrollArea = scrollAreaRef.current;
    if (enabled) scrollArea?.addEventListener("wheel", throttledOnScroll);
    else scrollArea?.removeEventListener("wheel", throttledOnScroll);

    return () => {
      scrollArea?.removeEventListener("wheel", throttledOnScroll);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [enabled]);

  return scrollAreaRef;
};
