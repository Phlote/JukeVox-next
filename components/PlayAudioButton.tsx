import React, { useState, useEffect } from "react";
import {PlayIcon, PauseIcon} from "../icons/PlayIcons";

const useAudio = url => {
  const [audio, setAudio] = useState(null)
  const [playing, setPlaying] = useState(false);

  useEffect(() => { setAudio(new Audio(url)) }, [url]);

  const toggle = () => setPlaying(!playing);

  useEffect(() => {
      playing ? audio?.play() : audio?.pause();
    },
    [playing]
  );

  useEffect(() => {
    audio?.addEventListener('ended', () => setPlaying(false));
    return () => {
      audio?.removeEventListener('ended', () => setPlaying(false));
    };
  }, []);

  return [playing, toggle];
};

const PlayAudioButton = ({ url }) => {
  const [playing, toggle] = useAudio(url);

  // @ts-ignore
  return <button onClick={toggle}>{playing ? <PauseIcon/> : <PlayIcon/>}</button>;
};

export default PlayAudioButton;