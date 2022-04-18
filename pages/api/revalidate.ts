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
  const { path } = req.body;

  try {
    console.log("Revalidating: ", path);
    await res.unstable_revalidate(path, { unstable_onlyGenerated: false });
    return res.json({ revalidated: true });
  } catch (err) {
    // If there was an error, Next.js will continue
    // to show the last successfully generated page
    console.error(err);
    return res.status(500).send("Error revalidating");
  }
}
