import React from "react";
import {
  CurationSubmissionFlow,
  useSubmissionFlowOpen,
} from "../CurationSubmissionFlow";
import { MobileModal } from "../Modal";

export const MobileSubmissionModal = () => {
  const [open, setOpen] = useSubmissionFlowOpen();

  const onClose = () => setOpen(false);

  return (
    <MobileModal open={open} onClose={onClose}>
      <CurationSubmissionFlow />
    </MobileModal>
  );
};
