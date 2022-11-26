import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import React, { useEffect } from "react";
import { supabase, oldSupabase } from "../lib/supabase";
import { OldSubmission, Submission } from "../types";

const migrateSubmissions = async () => {
  console.log(supabase,oldSupabase);

  const currentDB = supabase;

  const curatorSubs = await currentDB.from('Curator_Submission_Table').select();
  const artistSubs = await currentDB.from('Artist_Submission_Table').select();

  console.log({ curatorSubs, artistSubs });

  const oldSubmissions = await oldSupabase.from('submissions').select();

  console.log(oldSubmissions);

  const curatorSubmissions = oldSubmissions.data.map((s: OldSubmission) => {
    const { mediaType, artistName, curatorWallet, cosigns, mediaTitle, mediaURI, noOfCosigns, submissionTime, tags, mediaFormat } = s;
    if (mediaType !== 'File') {
      return {
        submissionTime: submissionTime,
        artistName: artistName,
        submitterWallet: curatorWallet,
        mediaTitle: mediaTitle,
        mediaFormat: mediaFormat,
        mediaURI: mediaURI,// Make this an array and fix the other mediaURI problems
        tags: tags,
        cosigns: cosigns,
        noOfCosigns: noOfCosigns,
        isArtist: false,
      };
    }
  });

  // const { data, error } = await supabase.from("comments").insert(comments);
};


function Scripts() {
  const router = useRouter();

  const handleSubmit = async ()=>{
     migrateSubmissions();
  }

  return (
    <div>
      <HollowButtonContainer
        className="lg:w-1/4  w-full"
        onClick={handleSubmit}
      >
        <HollowButton>Migrate submissions</HollowButton>
      </HollowButtonContainer>
    </div>
  )

}

export default Scripts;
