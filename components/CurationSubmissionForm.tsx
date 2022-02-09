import { useIsCurator } from "../hooks/useIsCurator";
import { HollowInputContainer, HollowInput } from "./HollowInput";

export const CurationSubmissionForm = (props) => {
  const canUseForm = useIsCurator();

  if (!canUseForm) return null;

  return (
    <div className="flex flex-col text-center w-96">
      <h1 className="mb-1 text-4xl underline-offset-8	underline">Submit</h1>
      <div className="h-4"></div>
      {/* todo dropdown */}
      <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
        <HollowInput type="text" placeholder="Media Type" />
      </HollowInputContainer>
      <div className="h-4" />
      <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
        <HollowInput type="text" placeholder="Artist Name" />
      </HollowInputContainer>
      <div className="h-4" />

      <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
        <HollowInput type="text" placeholder="Artist Wallet Address" />
      </HollowInputContainer>
      <div className="h-4" />

      <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
        <HollowInput type="text" placeholder="Song Title" />
      </HollowInputContainer>
      <div className="h-4" />

      <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
        <HollowInput type="text" placeholder="URL of NFT" />
      </HollowInputContainer>
      <div className="h-4" />

      <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
        <HollowInput
          type="text"
          placeholder="Marketplace (i.e. OpenSea, Zora)"
        />
      </HollowInputContainer>
      <div className="h-4" />

      {/* TODO: tag system */}
      <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
        <HollowInput type="text" placeholder="Tags" />
      </HollowInputContainer>
    </div>
  );
};
