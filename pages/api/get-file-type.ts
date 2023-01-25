import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const response = await fetch(req.body, { method: 'HEAD' });
  const result = response.headers.get("content-type");
  console.info(result);
  res.status(200).json(result);
}
