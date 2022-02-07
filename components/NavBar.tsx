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
        <div
          className="rounded-full  cursor-pointer flex justify-center items-center"
          style={{
            backgroundColor: "rgba(242, 244, 248, 0.17)",
            width: "70px",
            height: "70px",
          }}
        >
          <Image
            src="/app-drawer.svg"
            alt="app-drawer"
            height={36}
            width={36}
          ></Image>
        </div>
        <div className="w-4" />
        <Account triedToEagerConnect={triedToEagerConnect} />
      </div>
    </div>
  );
};
