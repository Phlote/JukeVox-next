import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import React, { useEffect } from "react";
import { supabase, oldSupabase } from "../lib/supabase";
import { OldSubmission, Submission } from "../types";

const missingUsers = [
  '0x14e5D778c77574106f8241303C9Ec5F418A82085',
  '0x68DCe5c8C8E5743D4d87eD70244565aFf29C81eA',
  '0x0717604B3B44b661408e187cB11F3Dc313480621',
  '0xf75779719f72f480e57b1ab06a729af2d051b1cd',
  '0xbF4CD9e881fCaC69Be12e14EF23e17bAAE5205d2',
  '0x18f194Ab7fCEcd004C835aa183A0e035A80232f4',
  '0xd248F2a4829D9C1B78eBA6D1e52703dA5599D65f',
  '0x64d857617eB0D31e0385944BD85729BF278ea41d',
]

function valueMatchesValues(value,values){
  return values.some(v=>v===value);
}

const migrateSubmissions = async () => {
  const currentDB = supabase;

  const curatorSubs = await currentDB.from('Curator_Submission_Table').select();
  const artistSubs = await currentDB.from('Artist_Submission_Table').select();

  const oldUsersWithProfiles = await oldSupabase.from('users_table').select();
  const oldUsersWithoutProfiles = await oldSupabase.from('users').select();
  const oldSubmissions = await oldSupabase.from('submissions').select();

  let usersWithProfiles = oldUsersWithProfiles.data.filter(u => u.username !== 'Ghostflow' && u.username !== 'hallway' && u.email !== 'theocarraraleao@gmail.com'); // Create a view for users with profiles on old db
  usersWithProfiles = usersWithProfiles.map(u => {
    const { address, city, created_at, email, profilePic, twitter, updateTime, username } = u;
    return {
      wallet: address,
      city: city,
      email: email,
      username: username,
      profilePic: profilePic,
      twitter: twitter,
      createdAt: created_at,
      updateTime: typeof updateTime === 'number' ? new Date(updateTime).toISOString() : null
    }
  })

  let usersWithoutProfiles = oldUsersWithoutProfiles.data.filter(u => u.username !== 'Ghostflow' && u.username !== 'hallway' && u.email !== 'theocarraraleao@gmail.com'); // Create a view for users with profiles on old db
  usersWithoutProfiles = usersWithoutProfiles.map(u => {
    const { address, city, created_at, email, profilePic, twitter, updateTime, username } = u;
    return {
      wallet: address,
      createdAt: created_at,
    }
  })

  let curatorSubmissions = oldSubmissions.data.filter(s => s.mediaType !== 'File' && s.mediaURI && !valueMatchesValues(s.curatorWallet, missingUsers));
  curatorSubmissions = curatorSubmissions.map((s: OldSubmission) => {
    const { artistName, curatorWallet, cosigns, mediaTitle, mediaURI, noOfCosigns, submissionTime, tags, username } = s;
    return {
      submissionTime: submissionTime,
      artistName: artistName,
      submitterWallet: curatorWallet,
      mediaTitle: mediaTitle,
      mediaURI: mediaURI,
      // @ts-ignore
      tags: JSON.parse(tags),
      cosigns: cosigns,
      noOfCosigns: noOfCosigns || 0,
      isArtist: false,
      username
    };
  });

  let missingWallets = oldSubmissions.data.filter(cs => {
    return !(usersWithoutProfiles.some(uwp => uwp.wallet === cs.curatorWallet));
  }); //TODO: Figure out what wallets are present in submissions from the users from old db

  console.log(missingWallets);

  let artistSubmissions = oldSubmissions.data.filter(s => s.mediaType === 'File' && s.mediaURI && s.curatorWallet !== '0xe3974e016f09e0572b2ccdbdb66ce011f9061880');
  artistSubmissions = artistSubmissions.map((s: OldSubmission) => {
    const { mediaType, artistName, curatorWallet, cosigns, mediaTitle, mediaURI, noOfCosigns, submissionTime, tags, mediaFormat } = s;
    return {
      submissionTime: submissionTime,
      artistName: artistName,
      submitterWallet: curatorWallet,
      mediaTitle: mediaTitle,
      mediaFormat: mediaFormat,
      mediaURI: mediaURI,
      // @ts-ignore
      tags: JSON.parse(tags),
      cosigns: cosigns,
      noOfCosigns: noOfCosigns || 0,
      isArtist: true,
    };
  });

  console.log(usersWithoutProfiles);

  console.log(curatorSubmissions);

  console.log(artistSubmissions);

  // artistSubmissions.map((s=>{
  //   if (typeof(s.noOfCosigns) !== "number") console.log(s);
  // }))
  //
  // curatorSubmissions.map((s=>{
  //   if (typeof(s.noOfCosigns) !== "number") console.log(s);
  // }))

  // const { data, error } = await supabase.from("Artist_Submission_Table").insert(artistSubmissions);
  // const { data, error } = await supabase.from("Curator_Submission_Table").insert(curatorSubmissions);
  // const { data, error } = await supabase.from("Users_Table").insert(usersWithProfiles); // gotta migrate users first
  // const { data, error } = await supabase.from("Users_Table").upsert(usersWithoutProfiles, {onConflict: "wallet"}).select();
  // console.log(data, error);
};


function Scripts() {
  const router = useRouter();

  const handleSubmit = async () => {
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
