// pages/api/revalidate.js

import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  // Check for secret to confirm this is a valid request
  // if (req.query.secret !== process.env.MY_SECRET_TOKEN) {
  //   return res.status(401).json({ message: 'Invalid token' })
  // }
  const { wallet, submissionID } = req.body;

  try {
    if (wallet) {
      console.log(`Revalidating: /profile/${wallet}`);
      await res.unstable_revalidate(`/profile/${wallet}`);
    } else console.log("wallet not provided or was falsy");

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
