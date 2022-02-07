import Link from "next/link";
import useEagerConnect from "../hooks/useEagerConnect";
import Account from "./Account";
import Image from "next/image";

export const NavBar = () => {
  const triedToEagerConnect = useEagerConnect();

  return (
    <div className="py-4 absolute w-full px-12">
      <div className="relative flex flex-row">
        <h1 className="text-6xl">Phlote</h1>
        <div className="flex-grow" />

        <Account triedToEagerConnect={triedToEagerConnect} />
      </div>
    </div>
  );
};
