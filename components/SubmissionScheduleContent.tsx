import React from "react";

const SubmissionScheduleContent = () => {
  return (
    <section className="flex items-center justify-center lg:mt-38">
      <div className=" w-full flex flex-col justify-center items-center pt-10 gap-4">
        <h1 className="text-center italic text-3xl sm:text-5xl font-extrabold">
          Submissions Schedule
        </h1>
        <h3 className="text-center italic opacity-70 font-light">
          All tracks that receive 5 cosigns are scheduled to be auctioned on Zora.
        </h3>
        <div className="relative hidden sm:block">
          <img className="w-full" src="/landing-page/submissions-dates-b&w.png" />
        </div>
      </div>
    </section>
  );
}

export default SubmissionScheduleContent;
