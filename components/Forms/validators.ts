import { CurationSubmission } from "./CurationSubmissionForm";

export const validateCurationSubmission = (values: CurationSubmission) => {
  const errors: Record<string, string> = {};
  if (!values.nftURL) {
    errors.nftURL = "Required";
  }
  if (!values.mediaType) {
    errors.mediaType = "Required";
  }
  //   if (!values.artistName) {
  //     errors.artistName = "Required";
  //   }
  return errors;
};
