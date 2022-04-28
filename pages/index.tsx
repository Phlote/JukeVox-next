import { useRouter } from "next/router";
import React from "react";
import { Footer } from "../components/Footer";
import Layout from "../components/Layouts";
import { SearchBar, useSearchTerm } from "../components/SearchBar";
import { useKeyPress } from "../hooks/useKeyPress";

function Home() {
  const [searchTerm, setSearchTerm] = useSearchTerm();
  const router = useRouter();

  useKeyPress("Enter", () => {
    if (!!searchTerm && searchTerm.length > 0) {
      router.push("/archive");
    }
  });

  return (
    <div className="flex flex-col justify-center items-center relative w-full">
      <div className="sm:hidden text-center mx-4 flex flex-col justify-center items-center">
        <h1 className="text-6xl">Phlote</h1>
        <div className="h-16"></div>
        <p>
          Share music links to directly support independent artists by bridging
          them to Web3.
        </p>
      </div>

      <div className="hidden sm:block w-full">
        <div className="relative w-full flex justify-center">
          <h2 className="absolute w-full bottom-32 text-center">
            Share music links to directly support independent artists by
            bridging them to Web3.{" "}
          </h2>
          <SearchBar placeholder="Search our archive" />
        </div>
      </div>
    </div>
  );
}

Home.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center flex-grow">
        {page}
      </div>
      <Footer />
    </Layout>
  );
};

export default Home;
