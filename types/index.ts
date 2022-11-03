export interface UserNonce {
  address: string;
  nonce: number;
}

type MediaType = "File" | "Link";
export interface Submission {
  submissionID: number;
  submissionTime: string;
  mediaType: MediaType;
  artistName: string;
  submitterWallet: string;
  mediaTitle: string;
  mediaFormat: string;
  mediaURI: string;
  tags?: string[];
  cosigns?: string[];
  noOfCosigns?: number;
  username: string;
  nftMetadata: string;
}

export interface SubmissionElasticSearchDocument {
  supabase_id: number;
  media_type: MediaType;
  artist_name: string;
  curator_wallet: string;
  media_title: string;
  media_uri: string;
  tags?: string[];
  submission_time: string;
}

//TODO: will this be used for submission NFTs? I would imagine no, so its name should rename
export interface CurationNFTMetadata {
  title: string;
  description: string;
  image: string;
  properties: {
    mediaType: MediaType;
    artistName: string;
    submitterWallet: string;
    mediaTitle: string;
    mediaURI: string;
    tags?: {
      name: string;
      value: string[];
    };
  };
}
