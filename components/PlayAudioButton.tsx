import React, { useEffect, useState } from "react";
import { PauseIcon, PlayIcon } from "../icons/PlayIcons";

const useAudio = (url) => {
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

const PlayAudioButton = ({ url }) => {
  const [playing, toggle] = useAudio(url);

  return (
    <button onClick={toggle}>{playing ? <PauseIcon /> : <PlayIcon />}</button>
  );
};

export default PlayAudioButton;
