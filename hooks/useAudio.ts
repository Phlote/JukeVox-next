import { useEffect, useState } from "react";

export const useAudio = (url) => {
  const [audio, setAudio] = useState(null);
  const [playing, setPlaying] = useState(false);

  useEffect(() => {
    setAudio(new Audio(url));
  }, [url]);

  const toggle = () => setPlaying(!playing);

  useEffect(() => {
    playing ? audio?.play() : audio?.pause();
  }, [playing]);

  useEffect(() => {
    audio?.addEventListener("ended", () => setPlaying(false));
    return () => {
      audio?.removeEventListener("ended", () => setPlaying(false));
    };
  }, [audio]);

  return [playing, toggle] as [boolean, () => void];
};
