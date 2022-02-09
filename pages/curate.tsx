import { CurationSubmissionForm } from "../components/CurationSubmissionForm";
import { DefaultLayout } from "../components/DefaultLayout";

export const CuratePage = (props) => {
  return (
    <DefaultLayout>
      <CurationSubmissionForm />
    </DefaultLayout>
  );
};

export default CuratePage;
