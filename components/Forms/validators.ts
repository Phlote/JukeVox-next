import { ethers } from "ethers";
import { Curation } from "../../types/curations";
import { supabase } from "../../utils/supabase";
import { UserProfile } from "./ProfileSettingsForm";

export const validateCurationSubmission = (values: Curation) => {
  const errors: Record<string, string> = {};
  if (!values.mediaURI) {
    errors.mediaURI = "Required";
  } else if (values.mediaURI) {
    let url;
    try {
      url = new URL(values.mediaURI);
    } catch (_) {
      errors.mediaURI = "Invalid URL";
    }

    if (!!url && url?.protocol !== "http:" && url?.protocol !== "https:") {
      errors.mediaURI = "Only http or https";
    }
  }
  if (!values.mediaType) {
    errors.mediaType = "Required";
  }
  if (!values.artistName) {
    errors.artistName = "Required";
  }
  if (!values.mediaTitle) {
    errors.mediaTitle = "Required";
  }
  if (!values.marketplace) {
    errors.marketplace = "Required";
  }

  if (!values.artistWallet) {
    errors.artistWallet = "Required";
  } else if (values.artistWallet) {
    if (!ethers.utils.isAddress(values.artistWallet)) {
      errors.artistWallet = "Invalid Address";
    }
  }

  return errors;
};

// TODO memoize?
export const usernameTaken = async (username: string, wallet: string) => {
  const query = await supabase.from("profiles").select().match({ username });
  return query.data.length > 0 && query.data[0].wallet !== wallet;
};

export const validateProfileSettings = async (values: UserProfile) => {
  const errors: Record<string, string> = {};
  if (values.username) {
    if (values.username.length < 4 || values.username.length > 15)
      errors.username =
        "Usernames must be between 4 and 15 characters in length!";

    if (await usernameTaken(values.username, values.wallet)) {
      errors.username = "Username taken!";
    }
  }
  //TODO: check if we have this info

  return errors;
};
