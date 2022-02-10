import { CurationSubmissionForm } from "../components/CurationSubmissionForm";
import { HomeLayout } from "../components/Layouts";

export const CuratePage = (props) => {
  return (
    <HomeLayout>
      <CurationSubmissionForm />
    </HomeLayout>
  );
};

export default CuratePage;
