import { NFTStorage } from "nft.storage";
const { NFT_STORAGE_API_KEY } = process.env;

declare global {
  namespace NodeJS {
    interface Global {
      nftStorage: any;
    }
  }
}

let nftStorage: NFTStorage;

if (!global.nftStorage) {
  global.nftStorage = new NFTStorage({ token: NFT_STORAGE_API_KEY });
}
nftStorage = global.nftStorage;

export default nftStorage;
