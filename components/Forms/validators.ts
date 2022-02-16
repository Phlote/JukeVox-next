import { CurationSubmission } from "./CurationSubmissionForm";

export const validateCurationSubmission = (values: CurationSubmission) => {
  const errors: Record<string, string> = {};
  if (!values.nftURL) {
    errors.nftURL = "Required";
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
  //TODO: if there is a value for artistWallet, check if it's on chain
  return errors;
};
