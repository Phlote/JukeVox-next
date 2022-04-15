import { NextApiRequest, NextApiResponse } from "next";
import { getAllSubmissionsWithFilter } from "../../utils/supabase";

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  const { filters } = request.body;

  const submissions = await getAllSubmissionsWithFilter(filters);

  response.status(200).json(submissions);
}
