import pinataSDK from "@pinata/sdk";
import { NextApiRequest, NextApiResponse } from "next";
import { Curation } from "../../types/curations";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const pinataApiKey = process.env.PINATA_API_KEY;
  const pinataSecretApiKey = process.env.PINATA_SECRET_API_KEY;
  const pinata = pinataSDK(pinataApiKey, pinataSecretApiKey);

  const {
    mediaType,
    artistName,
    artistWallet,
    curatorWallet,
    mediaTitle,
    mediaURI,
    marketplace,
    tags,
  } = request.body as Curation;

  const erc1155Metadata = {
    title: "Phlote Curation NFT",
    description: "Thanks for curating on Phlote",
    image: "url",
    properties: {
      mediaType,
      artistName,
      artistWallet,
      curatorWallet,
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
  console.log(pin);
  response.status(200).send({ cid: pin.IpfsHash });
}
