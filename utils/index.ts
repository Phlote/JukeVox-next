import debounce from "lodash.debounce";
import { GenericSubmission, SubmissionElasticSearchDocument } from "../types";

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
    console.error(err);
  });
}

export const submissionToElasticSearchDocument = (submission: GenericSubmission) => {
  const {
    submissionID,
    isArtist,
    artistName,
    submitterWallet,
    hotdropAddress,
    mediaTitle,
    mediaURI,
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
    submission_time: submissionTime,
    username,
    hotdrop_address: hotdropAddress
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
