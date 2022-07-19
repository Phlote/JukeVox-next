import throttle from "lodash.throttle";
import { useEffect } from "react";

export const useOnScrollToBottomWindow = (
  onBottom: () => void,
  enabled = true
) => {
  useEffect(() => {
    const onScroll = () => {
      const windowHeight =
        "innerHeight" in window
          ? window.innerHeight
          : document.documentElement.offsetHeight;
      const body = document.body;
      const html = document.documentElement;
      const docHeight = Math.max(
        body.scrollHeight,
        body.offsetHeight,
        html.clientHeight,
        html.scrollHeight,
        html.offsetHeight
      );
      const windowBottom = windowHeight + window.pageYOffset;

      // See if scroll is close enough to bottom to warrant loading more. 100px default buffer added
      if (windowBottom >= docHeight) {
        onBottom();
      }
    };

    const throttledOnScroll = throttle(onScroll, 1000, {
      trailing: true,
      leading: true,
    });

    if (enabled) window.onscroll = throttledOnScroll;
    else window.onscroll = undefined;

    return () => {
      window.onscroll = undefined;
    };
  }, [onBottom, enabled]);
};
