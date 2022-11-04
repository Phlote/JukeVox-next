import { ethers } from "ethers";
import { supabase } from "../../lib/supabase";
import { Submission } from "../../types";
import { UserProfile } from "./ProfileSettingsForm";

function cleanUrl(url: string) {
  const filter = ["http://", "https://", "www."];

  for (let i in filter) {
    url = url.replace(filter[i], "");
  }

  return url.replace(/\/+$/, "");
}

export const urlIsDuplicate = async (mediaURI: string) => {
  const query = await supabase
    .from('Curator_Submission_Table')
    .select()
    .ilike("mediaURI", `%${cleanUrl(mediaURI)}%`);
  return query.data.length > 0;
};

export const validateSubmission = async (values: Submission) => {
  const errors: Record<string, string> = {};
  if (values.mediaType !== "File") {
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
      if (!errors.mediaURI && process.env.NODE_ENV === "production") {
        if (await urlIsDuplicate(url.href)) {
          //Second if so that it only fetches when other errors are not present
          errors.mediaURI = "Duplicate submission";
        }
      }
    }
  }
  if (!values.artistName) {
    errors.artistName = "Required";
  }
  if (!values.mediaTitle) {
    errors.mediaTitle = "Required";
  }

  return errors;
};

// TODO memoize?
export const usernameTaken = async (username: string, wallet: string) => {
  const query = await supabase.from("Users_Table").select().match({ username });
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
  if (values.email) {
    if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(values.email))
      errors.email = "Invalid Email Address";
  }
  if (!values.username) {
    errors.username = "Required";
  }
  if (!values.email) {
    errors.email = "Required";
  }

  return errors;
};
