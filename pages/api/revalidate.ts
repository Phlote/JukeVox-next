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
  const { username, submissionAddress } = req.body;

  try {
    if (username) {
      console.log(`Revalidating: /profile/${username}`);
      await res.unstable_revalidate(`/profile/${username}`);

      // TODO: this should work for addresses as well

      const submissionsQuery = await supabase
        .from("submissions")
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

    if (submissionAddress) {
      console.log(`Revalidating: /submission/${submissionAddress}`);
      await res.unstable_revalidate(`/submission/${submissionAddress}`);
    } else console.log("submissionAddress not provided or was falsy");

    return res.json({ revalidated: true });
  } catch (err) {
    // If there was an error, Next.js will continue
    // to show the last successfully generated page
    console.error(err);
  }
}
