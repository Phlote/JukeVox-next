import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import React, { useEffect } from "react";
import { createClient } from "@supabase/supabase-js";
import { supabase, oldSupabase } from "../lib/supabase";
import { Submission } from "../types";

const migrateSubmissions = async () => {
  console.log(supabase,oldSupabase);

  const currentDB = supabase;

  const newSubmissions = await currentDB.from('Curator_Submission_Table').select();

  console.log(newSubmissions);

  const oldSubmissions = await oldSupabase.from('submissions').select();

  console.log(oldSubmissions);

  const curatorSubs = oldSubmissions.data.map((s: Submission) => {
    const { mediaType, artistName, curatorWallet } = s;
    if (mediaType !== 'File') {
      return {
        submissionTime: string,
        artistName: string,
        submitterWallet: string,
        mediaTitle: string,
        mediaFormat: string,
        mediaURI: string,
        tags: string,
        cosigns: string,
        noOfCosigns: number,
        username: string,
        nftMetadata: string,
        isArtist: boolean,
        mediaType: 'File' | 'Link'
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
        <HollowButton>Submit</HollowButton>
      </HollowButtonContainer>
    </div>
  )

}

export default Scripts;
