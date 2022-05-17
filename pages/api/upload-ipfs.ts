import { create } from "ipfs-http-client";
import { NextApiRequest, NextApiResponse } from "next";
import { CurationNFTMetadata, Submission } from "../../types";

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

    response.status(200).send({ uri: `ipfs://${pin}` });
  } catch (e) {
    console.error(e);
    response.status(500).send(e);
  }
}

const storeSubmissionOnIPFS = async (submission: Submission) => {
  const client = create(process.env.IPSS_NODE_URL ?? "http://127.0.0.1:5001");

  // call Core API methods
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
    },
  } as CurationNFTMetadata;

  if (tags) {
    erc1155Metadata.properties.tags = { name: "tags", value: tags };
  }

  const { cid } = await client.add(
    Buffer.from(JSON.stringify(erc1155Metadata))
  );
  console.log("Pinned here: ", cid);
  return cid;
};
