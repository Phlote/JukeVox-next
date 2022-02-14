import { NextApiRequest, NextApiResponse } from "next";
import { NFTStorage, File } from "nft.storage";
import { pack } from "ipfs-car/pack";

const { NFT_STORAGE_API_KEY } = process.env;

//TODO: make this a global
const client = new NFTStorage({ token: NFT_STORAGE_API_KEY });

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const metadata = await client.store({
    name: "example",
    description: "Welcome to phlote!",
    image: new File(
      [
        /* data */
      ],
      "example.jpg",
      { type: "image/jpg" }
    ),
  });
  response.status(200).send({ tokenURI: metadata.url });
}
