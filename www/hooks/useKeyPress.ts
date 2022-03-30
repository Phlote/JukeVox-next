import { useEffect } from "react";

type CallbackType = () => void;
export function useKeyPress(key: string, action: CallbackType) {
  useEffect(() => {
    function onKeyUp(event: KeyboardEvent) {
      if (event && event.key && event.key === key) {
        action();
      }
    }
    window.addEventListener("keyup", onKeyUp);
    return () => window.removeEventListener("keyup", onKeyUp);
  }, [key, action]);
}
