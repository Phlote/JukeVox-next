import { useRouter } from "next/router";
import "react-toastify/dist/ReactToastify.css";
import { HollowButton, HollowButtonContainer } from "../components/Hollow";
import React, { useEffect } from "react";
import { supabase, oldSupabase } from "../lib/supabase";
import { OldSubmission, Submission } from "../types";

// TODO: Remove this path from the website

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

const alreadyPresentUsernames = [
  'Ghostflow',
  'hallway',
]

export function valueMatchesValues(value, values) {
  return values.some(v => v === value);
}

export const migrateSubmissions = async () => {
  const currentDB = supabase;

  const curatorSubs = await currentDB.from('Curator_Submission_Table').select();
  const artistSubs = await currentDB.from('Artist_Submission_Table').select();

  const newUserProfiles = await currentDB.from('Users_Table').select();

  // const oldUsersWithProfiles = await oldSupabase.from('users_table').select();
  // const oldProfiles = await oldSupabase.from('profiles').select();
  // const oldUsersWithoutProfiles = await oldSupabase.from('users').select();
  // const oldSubmissions = await oldSupabase.from('submissions').select();

  console.log(curatorSubs);
  console.log(newUserProfiles);

  let missingUsers = curatorSubs.data.filter(u=>{
    return !(newUserProfiles.data.some(s => s.wallet === u.submitterWallet));
  })

  let missingUserWallets = [...new Set(missingUsers.map(s => s.submitterWallet))];

  console.log(missingUserWallets);

  let missingUsersToAdd = missingUserWallets.map(u => ({ wallet: u }))

  console.log(missingUsersToAdd);

  // const { data, error } = await supabase.from("Artist_Submission_Table").insert(artistSubmissions);
  // const { data, error } = await supabase.from("Curator_Submission_Table").insert(curatorSubmissions);
  const { data, error } = await supabase.from("Users_Table").insert(missingUsersToAdd); // gotta migrate users first
  // const { data, error } = await supabase.from("Users_Table_duplicate")
  //   .upsert(missingUsers, {onConflict: "wallet"}).select();
  console.log(data, error);
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
