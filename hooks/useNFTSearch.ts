import React, { useEffect } from "react";
import { usePhlote } from "./usePhlote";
import FuzzySearch from "fuzzy-search"; // Or: var FuzzySearch = require('fuzzy-search');
import { ArchiveCuration } from "../types/curations";

export const useGetAllNFTs = () => {
  const [nfts, setNFTs] = React.useState<ArchiveCuration[]>([]);

  const phlote = usePhlote();
  console.log(nfts);

  React.useEffect(() => {
    const getContent = () => {
      phlote.getAllCurations().then((content) => {
        console.log("content:", content);
        setNFTs(content as ArchiveCuration[]);
      });
    };

    if (phlote) {
      getContent();
      phlote.on("*", (res) => {
        console.log(res);
        if (res.event === "EditionCreated") {
          getContent();
        }
      });
    }

    return () => {
      phlote?.removeAllListeners();
    };
  }, [phlote]);

  return nfts;
};

export const useNFTSearch = (searchTerm = "") => {
  const nfts = useGetAllNFTs();
  const searcher = new FuzzySearch(nfts);
  return searcher.search(searchTerm + " ");
};
