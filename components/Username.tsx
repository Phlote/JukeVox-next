import Link from "next/link";
import { Curation } from "../types/curations";
import { ShortenedWallet } from "./ShortenedWallet";

interface Username {
  submission: Curation;
  linkToProfile: boolean;
}

export const Username: React.FC<Username> = ({ submission, linkToProfile }) => {
  const { username, curatorWallet } = submission;

  const content = username ? (
    username
  ) : (
    <ShortenedWallet wallet={curatorWallet} />
  );

  if (linkToProfile) {
    return (
      <Link href={`/profile/${encodeURIComponent(curatorWallet)}`} passHref>
        <div className="hover:opacity-50 cursor-pointer">{content}</div>
      </Link>
    );
  }

  return <span>{content}</span>;
};
