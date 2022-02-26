import { BigNumber } from "ethers";

export type ArchiveCuration = Curation & {
  transactionPending?: boolean;
  submissionTime: BigNumber | number;
};

type MediaType = "Audio" | "Text" | "Video" | "Visual Art";
export interface Curation {
  mediaType: MediaType;
  artistName: string;
  artistWallet: string;
  curatorWallet: string;
  mediaTitle: string;
  mediaURI: string;
  marketplace: string;
  tags?: string[];
}

export interface TokenMetadata {
  name: string;
  description: string;
  image: string;
  attributes: (
    | {
        trait_type: string;
        value: any;
        display_type?: undefined;
      }
    | {
        display_type: string;
        trait_type: string;
        value: number;
      }
  )[];
}

export const mappingAttributeToCurationField = {
  "Artist Waillet": "artistWallet",
  "Artist Wallet": "artistWallet",
  "Artist's Name": "artistName",
  "Link to OG NFT": "mediaURI",
  Marketplace: "marketplace",
  "Media Type": "mediaType",
  "Submission Date": "submissionTime",
  Tags: "tags",
  Title: "mediaTitle",
};
