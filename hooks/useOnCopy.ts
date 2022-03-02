import { useEffect } from "react";

export const useOnCopy = (ref, clipboardContents) => {
  useEffect(() => {
    function handleCopy(event) {
      if (ref.current && ref.current.contains(event.target)) {
        event.clipboardData.setData("text/plain", clipboardContents);
        event.preventDefault();
      }
    }

    document.addEventListener("copy", handleCopy);
    return () => {
      document.removeEventListener("copy", handleCopy);
    };
  }, [ref, clipboardContents]);
};
