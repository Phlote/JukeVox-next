import { useIsCurator } from "../hooks/useIsCurator";
import { HollowInputContainer, HollowInput } from "./Hollow";
import React, { useState } from "react";
import { usePhlote } from "../hooks/usePhlote";
import { HollowTagsInput } from "./Hollow/HollowTagsInput";

export const CurationSubmissionForm = (props) => {
  const isCurator = useIsCurator();

  //TODO: seems ugly
  const [mediaType, setMediaType] = useState<string>("");
  const [artistName, setArtistName] = useState<string>("");
  const [artistWallet, setArtistWallet] = useState<string>("");
  const [songTitle, setSongTitle] = useState<string>("");
  const [nftURL, setNFTURL] = useState<string>("");
  const [marketplace, setMarketplace] = useState<string>("");
  const [tags, setTags] = useState<string[]>([]);

  const phloteContract = usePhlote();

  const submitNFT = async () => {
    const res = await phloteContract.setSong(songTitle, artistName, nftURL, 10);
    console.log(res.hash);
  };

  // if (!isCurator) return null;

  return (
    <div className="flex flex-col text-center w-10/12">
      <h1 className="mb-1 text-4xl underline-offset-8	underline">Submit</h1>
      <div className="h-16"></div>
      <div className="grid grid-cols-2 gap-4">
        {/* todo dropdown */}
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Media Type"
            value={mediaType}
            onChange={({ target: { value } }) => setMediaType(value)}
          />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Artist Name"
            value={artistName}
            onChange={({ target: { value } }) => setArtistName(value)}
          />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Artist Wallet Address"
            value={artistWallet}
            onChange={({ target: { value } }) => setArtistWallet(value)}
          />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Song Title"
            value={songTitle}
            onChange={({ target: { value } }) => setSongTitle(value)}
          />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="URL of NFT"
            value={nftURL}
            onChange={({ target: { value } }) => setNFTURL(value)}
          />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Marketplace (i.e. OpenSea, Zora)"
            value={marketplace}
            onChange={({ target: { value } }) => setMarketplace(value)}
          />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowTagsInput tags={tags} setTags={setTags} />
        </HollowInputContainer>
      </div>
      <button onClick={submitNFT}>Submit</button>
    </div>
  );
};
