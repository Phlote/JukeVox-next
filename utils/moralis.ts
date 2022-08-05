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
  return (metadataFile as any).ipfs();
};

export const pinFile = async (b64File: string, name: string) => {
  await initializeMoralis();
  const file = new Moralis.File(name, { base64: b64File });
  await file.saveIPFS({ useMasterKey: true });
  return { uri: (file as any).ipfs(), hash: (file as any).hash() };
};
