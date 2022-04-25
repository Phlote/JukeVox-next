import React from "react";
import { MobileModal } from "../Modal";
import { SubmissionFlow, useSubmissionFlowOpen } from "../SubmissionFlow";

export const MobileSubmissionModal = () => {
  const [open, setOpen] = useSubmissionFlowOpen();

  const onClose = () => setOpen(false);
  return (
    <MobileModal open={open} onClose={onClose}>
      <SubmissionFlow />
    </MobileModal>
  );
};
