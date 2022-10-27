import { useState, useEffect, RefObject } from "react";

export const useVideo = (videoEl: RefObject<HTMLVideoElement>) => {
  const [video, setVideo] = useState(null);
  const [playing, setPlaying] = useState(false);

  const toggle = () => setPlaying(!playing);

  const pause = () => videoEl.current?.pause();

  useEffect(() => {
    playing ? videoEl.current?.play() : videoEl.current?.pause();
  }, [playing]);

  useEffect(() => {
    videoEl?.current?.addEventListener("ended", () => setPlaying(false));
    return () => {
      videoEl?.current?.removeEventListener("ended", () => setPlaying(false));
    };
  }, [video]);

  return [playing, toggle, pause] as [boolean, () => void, () => void];
};
