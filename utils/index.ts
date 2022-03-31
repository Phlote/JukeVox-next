import { Curation, CurationElasticSearchDocument } from "../types/curations";

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
  })
    .then((response) => response.json())
    .catch((e) => console.error(e));
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
