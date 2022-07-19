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
  });
}

export const submissionToElasticSearchDocument = (submission: Submission) => {
  const {
    id,
    mediaType,
    artistName,
    artistWallet,
    curatorWallet,
    mediaTitle,
    mediaURI,
    marketplace,
    tags,
    submissionTime,
    username,
  } = submission;
  return {
    supabase_id: id,
    media_type: mediaType,
    artist_name: artistName,
    artist_wallet: artistWallet,
    curator_wallet: curatorWallet,
    media_title: mediaTitle,
    media_uri: mediaURI,
    marketplace,
    tags,
    submission_time: submissionTime,
    username,
  } as SubmissionElasticSearchDocument;
};

export const cleanSubmission = (submission: Submission) => {
  const cleaned = { ...submission };
  if (!!submission.mediaURI) {
    if (submission.mediaURI.includes("opensea")) {
      cleaned.marketplace = "OpenSea";
    }
    if (submission.mediaURI.includes("catalog")) {
      cleaned.marketplace = "Catalog";
    }
    if (submission.mediaURI.includes("zora")) {
      cleaned.marketplace = "Zora";
    }
    if (submission.mediaURI.includes("foundation")) {
      cleaned.marketplace = "Foundation";
    }
    if (submission.mediaURI.includes("spotify")) {
      cleaned.marketplace = "Spotify";
    }
    if (submission.mediaURI.includes("soundcloud")) {
      cleaned.marketplace = "Soundcloud";
    }
    if (submission.mediaURI.includes("youtu")) {
      cleaned.marketplace = "Youtube";
    }
  }

  return cleaned;
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
