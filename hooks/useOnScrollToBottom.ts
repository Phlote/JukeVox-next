import throttle from "lodash.throttle";
import React from "react";

export const useOnScrollToBottom = (
  onBottom: () => Promise<any>,
  enabled = true,
  buffer = 25
) => {
  const scrollAreaRef = React.useRef(null);

  const onScroll = async (ref) => {
    if (!ref.current) return;
    const { scrollHeight, scrollTop, clientHeight } = ref.current;
    console.log("onScroll triggered");
    // See if scroll is close enough to bottom to warrant loading more. 100px default buffer added
    console.log("scroll Height: ", scrollHeight);
    console.log("scrollTop: ", scrollTop);
    console.log("clientHeight: ", clientHeight);
    if (scrollHeight - Math.abs(scrollTop) < clientHeight + buffer) {
      console.log("calling OnBottom");
      await onBottom();
    }
  };

  const throttledOnScroll = throttle(() => onScroll(scrollAreaRef), 1000);

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
