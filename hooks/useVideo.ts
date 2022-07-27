import { useState, useEffect } from "react";

export const useVideo = (videoEl) => {
  const [video, setVideo] = useState(null);
  const [playing, setPlaying] = useState(false);

  const toggle = () => setPlaying(!playing);

  useEffect(() => {
    playing ? videoEl.current?.play() : videoEl.current?.pause();
  }, [playing]);

  useEffect(() => {
    videoEl?.current?.addEventListener("ended", () => setPlaying(false));
    return () => {
      videoEl?.current?.removeEventListener("ended", () => setPlaying(false));
    };
  }, [video]);

  return [playing, toggle] as [boolean, () => void];
};