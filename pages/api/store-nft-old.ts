import { NextApiRequest, NextApiResponse } from "next";
import { File } from "nft.storage";
import { Curation } from "../../types/curations";
import { PHLOTE_CURATION_NFT_IMAGE } from "./common";
import nftStorage from "./lib/nftStorage";

const getOptionalFields = (
  body: Curation
): { trait_type: string; value: any }[] => {
  let fields = [];
  const { tags } = body;

  if (tags && tags.length > 0) {
    fields.push({ trait_type: "Tags", value: tags });
  }

  return fields;
};

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const {
    mediaType,
    artistName,
    artistWallet,
    mediaTitle,
    nftURL,
    marketplace,
    tags,
  } = request.body;

  const metadata = await nftStorage.store({
    name: "Phlote Curation NFT",
    description: "Thanks for curating on Phlote",
    image: new File(
      [Buffer.from(PHLOTE_CURATION_NFT_IMAGE, "base64")],
      "PhloteCurationNFT.png",
      {
        type: "image/png",
      }
    ),
    attributes: [
      { trait_type: "Media Type", value: mediaType },
      { trait_type: "Artist's Name", value: artistName },
      { trait_type: "Title", value: mediaTitle },
      { trait_type: "Link to OG NFT", value: nftURL },
      { trait_type: "Marketplace", value: marketplace },
      { trait_type: "Artist Wallet", value: artistWallet },
      {
        display_type: "date",
        trait_type: "Submission Date",
        value: Date.now(),
      },
      ...getOptionalFields(request.body),
    ],
  });

  response.status(200).send({ tokenURI: metadata.url });
}