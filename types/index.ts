export interface UserNonce {
  address: string;
  nonce: number;
}

export interface GenericSubmission {
  submissionID?: string, // UUID Required but generated by DB
  isArtist: boolean,
  hotdropAddress: string,
  mediaURI: string,
  submitterWallet: string,
  mediaTitle: string,

  noOfCosigns?: number,
  marketplaceItemID?: string, // UUID,
  artistName?: string,
  username?: string, // Should be removed (relation)
  submissionTime?: string, // timestamptz
  cosigns?: string[], // Array of user wallets that have cosigned this submission
  playlistIDs?: string[] // UUID,
  mediaType?: string, // Should be removed (isArtist),
  tags?: string[], // Array of strings
}

export interface CuratorSubmission extends GenericSubmission {
  // Required
  isArtist: false,
}

export interface ArtistSubmission extends GenericSubmission {
  // Required
  isArtist: true,

  // Optional
  mediaFormat?: string,
  collaboratorWalletAddresses?: string, // Array of wallets
}

export interface OldSubmission {
  id: number;
  submissionTime: string;
  mediaType: "File" | "Link";
  artistName: string;
  artistWallet: string;
  curatorWallet: string;
  mediaTitle: string;
  mediaFormat: string;
  mediaURI: string;
  marketplace: string;
  tags?: string[];
  cosigns?: string[];
  noOfCosigns?: number;
  username: string;
  nftMetadata: string;
}

export interface SubmissionElasticSearchDocument {
  supabase_id: string;
  is_artist: boolean;
  artist_name: string;
  curator_wallet: string;
  media_title: string;
  media_uri: string;
  tags?: string[];
  submission_time: string;
  hotdrop_address: string;
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
