import sgMail from '@sendgrid/mail'
import { NextApiRequest, NextApiResponse } from 'next';

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

export default async (req: NextApiRequest, res: NextApiResponse) => {
  console.log("RUNS?");
  const { email, subject, message, name } = req.body
  const msg = {
    to: 'theo@phlote.co',
    from: email,
    subject,
    name,
    text: message,
  };

  try {
    await sgMail.send(msg);
    res.json({ message: `Email has been sent` })
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: 'Error sending email' })
  }
}
