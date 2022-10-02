import { nextApiRequest } from "../utils";

export const sendEmail = async (
  email: string,
  name: string,
  subject: string,
  message: string
) => {
  return await nextApiRequest("send-email", "POST", {
    email, name, subject, message
  });
};
