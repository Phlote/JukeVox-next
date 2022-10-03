let profile: any | null = null;
export let setProfile = (profileData: any) => {
  profile = profileData;
  console.log(profile);
};

export let getLensProfile = () => {
  return profile;
};
