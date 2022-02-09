import { HollowInputContainer, HollowInput } from "./HollowInput";

export const CurationSubmissionForm = (props) => {
  <div className="flex flex-col mx-auto w-4/5">
    <h1 className="text-center my-8 text-4xl underline-offset-8	underline">
      Submit
    </h1>
    <div className="h-4"></div>
    {/* todo dropdown */}
    <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
      <HollowInput className="flex-grow" type="text" placeholder="Media Type" />
    </HollowInputContainer>
    <div className="h-4" />
    <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
      <HollowInput
        className="flex-grow"
        type="text"
        placeholder="Artist Name"
      />
    </HollowInputContainer>
    <div className="h-4" />

    <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
      <HollowInput
        className="flex-grow"
        type="text"
        placeholder="Artist Wallet Address"
      />
    </HollowInputContainer>
    <div className="h-4" />

    <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
      <HollowInput className="flex-grow" type="text" placeholder="Song Title" />
    </HollowInputContainer>
    <div className="h-4" />

    <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
      <HollowInput className="flex-grow" type="text" placeholder="URL of NFT" />
    </HollowInputContainer>
    <div className="h-4" />

    <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
      <HollowInput
        className="flex-grow"
        type="text"
        placeholder="Marketplace (i.e. OpenSea, Zora)"
      />
    </HollowInputContainer>
    <div className="h-4" />

    {/* TODO: tag system */}
    <HollowInputContainer backgroundColor="rgba(101, 101, 101, 0.17)">
      <HollowInput className="flex-grow" type="text" placeholder="Tags" />
    </HollowInputContainer>
  </div>;
};
