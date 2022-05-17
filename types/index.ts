export interface UserNonce {
  address: string;
  nonce: number;
}

//TODO include the subgraph project in this repo, use types as it is in graphql
type MediaType = "Audio" | "Text" | "Video" | "Visual Art";
export interface Submission {
  id: number;
  address: string;
  timestamp: number;
  mediaType: MediaType;
  artistName: string;
  artistWallet: string;
  submitterWallet: string;
  mediaTitle: string;
  mediaURI: string;
  marketplace: string;
  tags?: string[];
  cosigns?: string[];
}

export interface SubmissionElasticSearchDocument {
  supabase_id: number;
  media_type: MediaType;
  artist_name: string;
  artist_wallet: string;
  curator_wallet: string;
  media_title: string;
  media_uri: string;
  marketplace: string;
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
    artistWallet: string;
    submitterWallet: string;
    mediaTitle: string;
    mediaURI: string;
    marketplace: string;
    tags?: {
      name: string;
      value: string[];
    };
  };
}
