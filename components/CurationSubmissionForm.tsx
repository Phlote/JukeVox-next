import { useIsCurator } from "../hooks/useIsCurator";
import { HollowInputContainer, HollowInput } from "./HollowInput";
import { HollowTagsInput } from "./HollowTagsInput";
import React, { useState } from "react";

export const CurationSubmissionForm = (props) => {
  const canUseForm = useIsCurator();
  const [tags, setTags] = useState<string[]>([]);

  if (!canUseForm) return null;

  return (
    <div className="flex flex-col text-center w-10/12">
      <h1 className="mb-1 text-4xl underline-offset-8	underline">Submit</h1>
      <div className="h-16"></div>
      <div className="grid grid-cols-2 gap-4">
        {/* todo dropdown */}
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput type="text" placeholder="Media Type" />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput type="text" placeholder="Artist Name" />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput type="text" placeholder="Artist Wallet Address" />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput type="text" placeholder="Song Title" />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput type="text" placeholder="URL of NFT" />
        </HollowInputContainer>

        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          <HollowInput
            type="text"
            placeholder="Marketplace (i.e. OpenSea, Zora)"
          />
        </HollowInputContainer>

        {/* TODO: tag system */}
        <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
          {/* <HollowInput type="text" placeholder="Tags" /> */}
          <HollowTagsInput tags={tags} setTags={setTags} />
        </HollowInputContainer>
      </div>
    </div>
  );
};
