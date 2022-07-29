import { PauseIcon, PlayIcon } from "../icons/PlayIcons";
import { useAudio } from "../hooks/useAudio";
import { useVideo } from "../hooks/useVideo";

export const PlayButtonAudio = ({ url }) => {
  const [playing, toggle] = useAudio(url);

  return (
    <button onClick={toggle}>{playing ? <PauseIcon /> : <PlayIcon />}</button>
  );
};

export const PlayButtonVideo = ({ el }) => {
  const [playing, toggle] = useVideo(el);

  return (
    <button onClick={toggle}>{playing ? <PauseIcon /> : <PlayIcon />}</button>
  );
};
