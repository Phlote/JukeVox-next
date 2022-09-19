let profile: any | null = null;
export let setProfile = (profileData: any) => {
  profile = profileData;
  console.log(profile);
};

export let getProfile = () => {
  return profile;
};
