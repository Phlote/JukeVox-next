import { PauseIcon, PlayIcon } from "../icons/PlayIcons";
import { useAudio } from "../hooks/useAudio";
import { useVideo } from "../hooks/useVideo";
import { useEffect } from "react";

export const PlayButtonAudio = ({ url }) => {
  const [playing, toggle, pause] = useAudio(url);

  useEffect(() => {
    return pause;
  }, []);

  return (
    <button onClick={toggle}>{playing ? <PauseIcon /> : <PlayIcon />}</button>
  );
};

export const PlayButtonVideo = ({ el }) => {
  const [playing, toggle, pause] = useVideo(el);

  useEffect(() => {
    return pause;
  }, []);

  return (
    <button onClick={toggle}>{playing ? <PauseIcon /> : <PlayIcon />}</button>
  );
};
