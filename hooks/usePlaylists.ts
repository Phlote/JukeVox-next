import { useEffect, useState } from "react";
import { supabase } from "../lib/supabase";

export const usePlaylists = () => {
  const [playlists, setPlaylists] = useState<Array<Object>>([]);

  // TODO: Run this query more efficiently, re-use the result from the supabase call

  useEffect(() => {
    const getPlaylists = async () => {
      const res = await supabase
        .from('Playlists_Table')
        .select()

      setPlaylists(res.data.map(p => { return { id: p.playlistID, name: p.playlistName }}));
    };
    getPlaylists();
  }, []);

  return playlists;
};
