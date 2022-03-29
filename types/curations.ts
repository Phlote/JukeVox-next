import { BigNumber } from "ethers";

export type ArchiveCuration = Curation & {
  transactionPending?: boolean;
  submissionTime: BigNumber | number;
};

// TODO: use our generated types

type MediaType = "Audio" | "Text" | "Video" | "Visual Art";
export interface Curation {
  id: BigNumber;
  mediaType: MediaType;
  artistName: string;
  artistWallet: string;
  curatorWallet: string;
  mediaTitle: string;
  mediaURI: string;
  marketplace: string;
  tags?: string[];
}

export interface CurationElasticSearchDocument {
  media_type: MediaType;
  artist_name: string;
  artist_wallet: string;
  curator_wallet: string;
  media_title: string;
  media_uri: string;
  marketplace: string;
  tags?: string[];
}
