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
  const { username } = req.body;

  try {
    console.log("Revalidating: /archive");
    await res.unstable_revalidate("/archive");
    if (username) {
      console.log(`Revalidating: /profile/${username}`);
      await res.unstable_revalidate("/archive");
    } else console.log("username not provided or was falsy");

    return res.json({ revalidated: true });
  } catch (err) {
    // If there was an error, Next.js will continue
    // to show the last successfully generated page
    console.error(err);
    return res.status(500).send("Error revalidating");
  }
}
