import Link from "next/link";
import useEagerConnect from "../hooks/useEagerConnect";
import Account from "./Account";
import Image from "next/image";

export const NavBar = () => {
  const triedToEagerConnect = useEagerConnect();

  return (
    <nav className="flex justify-evenly	py-4">
      <Image width={160} height={20} src="/logo.png" alt="logo" />
      <Account triedToEagerConnect={triedToEagerConnect} />
    </nav>
  );
};
