// pages/api/revalidate.js

import { NextApiRequest, NextApiResponse } from "next";
import { supabase } from "../../lib/supabase";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  // Check for secret to confirm this is a valid request
  // if (req.query.secret !== process.env.MY_SECRET_TOKEN) {
  //   return res.status(401).json({ message: 'Invalid token' })
  // }
  const { username, submissionID } = req.body;

  try {
    if (username) {
      console.log(`Revalidating: /profile/${username}`);
      await res.unstable_revalidate(`/profile/${username}`);

      const submissionsQuery = await supabase
        .from('Curator_Submission_Table')
        .select()
        .match({ username });

      if (submissionsQuery.error) throw submissionsQuery.error;

      // update all the submission pages for that user
      await Promise.all(
        submissionsQuery.data.map(async ({ id }) => {
          console.log(`Revalidating: /submission/${id}`);
          await res.unstable_revalidate(`/submission/${id}`);
        })
      );
    } else console.log("username not provided or was falsy");

    if (submissionID) {
      console.log(`Revalidating: /submission/${submissionID}`);
      await res.unstable_revalidate(`/submission/${submissionID}`);
    } else console.log("submissionID not provided or was falsy");

    return res.json({ revalidated: true });
  } catch (err) {
    // If there was an error, Next.js will continue
    // to show the last successfully generated page
    console.error(err);
    return res.status(500).send("Error revalidating");
  }
}
