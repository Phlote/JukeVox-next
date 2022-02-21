import { ethers, utils } from "ethers";
import { Curation } from "./CurationSubmissionForm";

export const validateCurationSubmission = (values: Curation) => {
  const errors: Record<string, string> = {};
  if (!values.mediaURI) {
    errors.mediaURI = "Required";
  } else if (values.mediaURI) {
    let url;
    try {
      url = new URL(values.mediaURI);
    } catch (_) {
      errors.mediaURI = "Invalid URL";
    }
  }
  if (!values.mediaType) {
    errors.mediaType = "Required";
  }
  if (!values.artistName) {
    errors.artistName = "Required";
  }
  if (!values.mediaTitle) {
    errors.mediaTitle = "Required";
  }
  if (!values.marketplace) {
    errors.marketplace = "Required";
  }

  if (!values.artistWallet) {
    errors.artistWallet = "Required";
  } else if (values.artistWallet) {
    if (!ethers.utils.isAddress(values.artistWallet)) {
      errors.artistWallet = "Invalid Address";
    }
  }

  //TODO: if there is a value for artistWallet, check if it's on chain
  return errors;
};
