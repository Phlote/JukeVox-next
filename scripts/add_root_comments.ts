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

  const submissions = await supabase.from("submissions").select();
  if (submissions.error) {
    console.error("error getting submissions");
    return;
  }

  for (let s in submissions.data as Submission[]) {
  }

  const comments = submissions.data.map((s: Submission) => {
    return {
      id: s.id,
      slug: `submission-root-${cuid.slug()}`,
      authorId: s.curatorWallet,
      isApproved: true,
    };
  });

  await supabase.from("comments").insert(comments);
};

addRootComments();
