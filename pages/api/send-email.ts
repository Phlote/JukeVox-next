import sgMail from '@sendgrid/mail'
import { NextApiRequest, NextApiResponse } from 'next';

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

export default async function handler (req: NextApiRequest, res: NextApiResponse) {
  const { email, subject, message, name } = req.body
  const msg = {
    to: email,
    from: 'theo@phlote.co',// TEMP
    subject,
    name,
    text: message,
  };

  try {
    let result = await sgMail.send(msg);
    res.status(200).send({ result });
    // res.json({ message: `Email has been sent` })
  } catch (error) {
    console.error(error);
    res.status(500).send(error)
  }
}
