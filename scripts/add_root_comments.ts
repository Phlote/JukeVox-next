import { createClient } from "@supabase/supabase-js";
import cuid from "cuid";
import { Submission } from "../types";

const addRootComments = async () => {
  const { NEXT_PUBLIC_SUPABASE_URL, NEXT_PUBLIC_SUPABASE_ANON_KEY } =
    process.env;

  const supabase = createClient(
    NEXT_PUBLIC_SUPABASE_URL,
    NEXT_PUBLIC_SUPABASE_ANON_KEY
  );

  supabase.from("comments").delete();

  const submissions = await supabase.from('Curator_Submission_Table').select();
  if (submissions.error) {
    console.error("error getting submissions");
    return;
  }

  const comments = submissions.data.map((s: Submission) => {
    return {
      threadId: s.id,
      slug: `submission-root-${cuid.slug()}`,
      authorId: s.curatorWallet,
      isApproved: true,
    };
  });

  const { data, error } = await supabase.from("comments").insert(comments);
  console.error(error);
};

addRootComments();
