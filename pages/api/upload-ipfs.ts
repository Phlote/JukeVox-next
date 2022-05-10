import pinataSDK from "@pinata/sdk";
import { NextApiRequest, NextApiResponse } from "next";
import { Submission } from "../../types";

const { PINATA_API_KEY, PINATA_SECRET_API_KEY } = process.env;

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { submission, wallet } = request.body;

  try {
    const submissionWithSubmitterInfo = {
      submitterWallet: wallet,
      ...submission,
    };

    const pin = await storeSubmissionOnIPFS(submissionWithSubmitterInfo);

    response
      .status(200)
      .send({ uri: `https://gateway.pinata.cloud/ipfs/${pin.IpfsHash}` });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}

const storeSubmissionOnIPFS = async (submission: Submission) => {
  const pinata = pinataSDK(PINATA_API_KEY, PINATA_SECRET_API_KEY);

  const {
    mediaType,
    artistName,
    artistWallet,
    submitterWallet,
    mediaTitle,
    mediaURI,
    marketplace,
    tags,
  } = submission;

  const erc1155Metadata = {
    title: "Phlote Submission NFT",
    description: "Thanks for submitting to Phlote!",
    image: "url",
    properties: {
      mediaType,
      artistName,
      artistWallet,
      submitterWallet,
      mediaTitle,
      mediaURI,
      marketplace,
      tags: {
        name: "tags",
        value: tags,
      },
    },
  };
  const pin = await pinata.pinJSONToIPFS(erc1155Metadata);
  console.log("Pinned here: ", pin);
  return pin;
};
