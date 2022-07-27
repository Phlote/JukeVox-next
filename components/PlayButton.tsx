import { PauseIcon, PlayIcon } from "../icons/PlayIcons";

const PlayButton = ({ hook, media }) => {
  const [playing, toggle] = hook(media);

  return (
    <button onClick={toggle}>{playing ? <PauseIcon /> : <PlayIcon />}</button>
  );
};

export default PlayButton;
