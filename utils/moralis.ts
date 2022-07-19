import Moralis from "moralis/node";
import { Submission } from "../types";

let initialized: boolean;

const initializeMoralis = async () => {
  const serverUrl = process.env.MORALIS_SERVER_URL;
  const appId = process.env.MORALIS_APP_ID;
  const masterKey = process.env.MORALIS_MASTER_KEY;
  if (!initialized) {
    await Moralis.start({ serverUrl, appId, masterKey });
    initialized = true;
  }
};

// See here: https://gateway.pinata.cloud/ipfs/Qmb8Jmabe5agSBxjScYQ9cyZvbBopMRUvnFg3SpJTA4jp6
const defaultSubmissionImage =
  "ipfs://Qmb8Jmabe5agSBxjScYQ9cyZvbBopMRUvnFg3SpJTA4jp6";

export const storeSubmissionOnIPFS = async (
  submission: Submission,
  imageUrl = defaultSubmissionImage
) => {
  await initializeMoralis();
  const { artistName, artistWallet, curatorWallet, mediaTitle, mediaURI } =
    submission;

  //TODO: update for file uplaods
  const nftMetadata = {
    name: mediaTitle,
    description: "Submission on Phlote.xyz",
    image: imageUrl,
    external_url: mediaURI,
    attributes: [
      { trait_type: "string", value: artistName },
      { trait_type: "string", value: artistWallet },
      { trait_type: "string", value: curatorWallet },
      { trait_type: "string", value: mediaTitle },
      { trait_type: "string", value: mediaURI },
    ],
  };

  const metadataFile = new Moralis.File("metadata.json", {
    base64: Buffer.from(JSON.stringify(nftMetadata)).toString("base64"),
  });
  await metadataFile.saveIPFS({ useMasterKey: true });

  const uploadedSubmission = new Moralis.Object("Submissions");
  uploadedSubmission.set("id", submission.id);
  uploadedSubmission.set("metadata", metadataFile);
  await uploadedSubmission.save();

  // Retrieve file
  const query = new Moralis.Query("Submissions");
  query.equalTo("id", submission.id);
  const res = await query.find();
  return res[0].get("metadata").ipfs();
};

export const storeAudioOnIpfs = async (
  submission: Submission,
  imageUrl = defaultSubmissionImage
) => {};
