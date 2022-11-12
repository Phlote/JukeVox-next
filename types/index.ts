export interface UserNonce {
  address: string;
  nonce: number;
}

export interface Submission {
  submissionID: number;
  submissionTime: string;
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
  isArtist: boolean;
  mediaType?: 'File' | 'Link';
}

export interface SubmissionElasticSearchDocument {
  supabase_id: number;
  is_artist: boolean;
  artist_name: string;
  curator_wallet: string;
  media_title: string;
  media_uri: string;
  tags?: string[];
  submission_time: string;
}

export type ContractRes = {
  hash?: string,
  code?: number,
  message?: string
}

//TODO: will this be used for submission NFTs? I would imagine no, so its name should rename
export interface CurationNFTMetadata {
  title: string;
  description: string;
  image: string;
  properties: {
    isArist: boolean;
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
