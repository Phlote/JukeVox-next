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
    if (Math.abs(scrollHeight - scrollTop) < clientHeight + buffer) {
      await onBottom();
    }
  };

  const throttledOnScroll = throttle(() => onScroll(scrollAreaRef), 1000, {
    trailing: true,
    leading: true,
  });

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
