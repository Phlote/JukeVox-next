import { Curation, CurationElasticSearchDocument } from "../types/curations";

export function nextApiRequest(
  path: string,
  method = "GET",
  data?: Record<string, any>
): Promise<Record<string, any>> {
  return fetch(`/api/${path}`, {
    method: method,
    headers: {},
    body: data ? JSON.stringify(data) : undefined,
  }).then((response) => {
    if (!response.ok) throw `Error calling /api/${path}`;

    return response.json();
  });
}

export const curationToElasticSearchDocument = (curation: Curation) => {
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
  } = curation;
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
  } as CurationElasticSearchDocument;
};

export const cleanSubmission = (submission: Curation) => {
  const cleaned = { ...submission };
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

  return cleaned;
};
