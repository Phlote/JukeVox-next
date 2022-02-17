import { NextApiRequest, NextApiResponse } from "next";
import { NFTStorage, File } from "nft.storage";
import { PHLOTE_CURATION_NFT_IMAGE } from "./common";
import { Curation } from "../../components/Forms/CurationSubmissionForm";
import nftStorage from "./lib/nftStorage";

const getOptionalFields = (
  body: Curation
): { trait_type: string; value: any }[] => {
  let fields = [];
  const { tags, artistWallet } = body;

  if (tags && tags.length > 0) {
    fields.push({ trait_type: "Tags", value: tags });
  }

  if (artistWallet) {
    fields.push({ trait_type: "Artist Wallet", value: artistWallet });
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

  // const metadata = await nftStorage.store({
  //   name: "Phlote Curation NFT",
  //   description: "Thanks for curating on Phlote",
  //   image: new File(
  //     [Buffer.from(PHLOTE_CURATION_NFT_IMAGE, "base64")],
  //     "PhloteCurationNFT.png",
  //     {
  //       type: "image/png",
  //     }
  //   ),
  //   attributes: [
  //     { trait_type: "Media Type", value: mediaType },
  //     { trait_type: "Artist's Name", value: artistName },
  //     { trait_type: "Title", value: mediaTitle },
  //     { trait_type: "Link to OG NFT", value: nftURL },
  //     { trait_type: "Marketplace", value: marketplace },
  //     {
  //       display_type: "date",
  //       trait_type: "Submission Date",
  //       value: Date.now(),
  //     },
  //     ...getOptionalFields(request.body),
  //   ],
  // });

  // console.log(metadata);
  // response.status(200).send({ tokenURI: metadata.url });
  response.status(200).send({
    tokenURI:
      "ipfs://bafyreigswa467pbzdbre4n4wlq2w5qreln3elmum2npkvcyt2ow4hgky6i/metadata.json",
  });
}
