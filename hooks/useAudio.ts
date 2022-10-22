import { useEffect, useRef, useState } from "react";

export const useAudio = (url) => {
  const audio = useRef<HTMLAudioElement>(null);
  const [playing, setPlaying] = useState(false);

  useEffect(() => {
    audio.current = new Audio(url);
  }, [url]);

  const toggle = () => setPlaying(!playing);

  const pause = () => audio.current?.pause();

  useEffect(() => {
    playing ? audio.current?.play() : audio.current?.pause();
  }, [playing]);

  useEffect(() => {
    audio.current?.addEventListener("ended", audio.current?.pause);
    return () => {
      audio.current?.removeEventListener("ended", audio.current?.pause);
    };
  }, [audio]);

  return [playing, toggle, pause] as [boolean, () => void, () => void];
};
