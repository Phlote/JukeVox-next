import { NextApiRequest, NextApiResponse } from "next";
import { getSubmissionsWithFilter } from "../../utils/supabase";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { filters } = request.body;

  const submissions = await getSubmissionsWithFilter(filters);

  response.status(200).json(submissions);
}
