import debounce from "lodash.debounce";
import { Submission, SubmissionElasticSearchDocument } from "../types";

export function nextApiRequest(
  path: string,
  method = "GET",
  data?: Record<string, any>
): Promise<Record<string, any>> {
  return fetch(`/api/${path}`, {
    method: method,
    headers: {
      "Content-Type": "application/json",
    },
    body: data ? JSON.stringify(data) : undefined,
  }).then((response) => {
    if (!response.ok) throw `Error calling /api/${path}`;
    return response.json();
  }).catch(err=>{
    console.log(err);
  });
}

export const submissionToElasticSearchDocument = (submission: Submission) => {
  const {
    submissionID,
    isArtist,
    artistName,
    submitterWallet,
    mediaTitle,
    mediaURI,
    tags,
    submissionTime,
    username,
  } = submission;
  return {
    supabase_id: submissionID,
    is_artist: isArtist,
    artist_name: artistName,
    curator_wallet: submitterWallet,
    media_title: mediaTitle,
    media_uri: mediaURI,
    tags,
    submission_time: submissionTime,
    username,
  } as SubmissionElasticSearchDocument;
};

export function asyncDebounce(func, wait) {
  const debounced = debounce((resolve, reject, args) => {
    func(...args)
      .then(resolve)
      .catch(reject);
  }, wait);
  return (...args) =>
    new Promise((resolve, reject) => {
      debounced(resolve, reject, args);
    });
}
