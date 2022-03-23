export type ArchiveCuration = Curation;

type MediaType = "Audio" | "Text" | "Video" | "Visual Art";
export interface Curation {
  id: number;
  mediaType: MediaType;
  artistName: string;
  artistWallet: string;
  curatorWallet: string;
  mediaTitle: string;
  mediaURI: string;
  marketplace: string;
  tags?: string[];
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
