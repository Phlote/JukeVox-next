type MediaType = "Audio" | "Text" | "Video" | "Visual Art";
export interface Curation {
  id: number;
  submissionTime: string;
  mediaType: MediaType;
  artistName: string;
  artistWallet: string;
  curatorWallet: string;
  mediaTitle: string;
  mediaURI: string;
  marketplace: string;
  tags?: string[];
  cosigns: string[];
}

export interface CurationNFTMetadata {
  title: string;
  description: string;
  image: string;
  properties: {
    mediaType: MediaType;
    artistName: string;
    artistWallet: string;
    curatorWallet: string;
    mediaTitle: string;
    mediaURI: string;
    marketplace: string;
    tags?: {
      name: string;
      value: string[];
    };
  };
}

export interface CurationElasticSearchDocument {
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
