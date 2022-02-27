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
