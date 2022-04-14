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
    <div className="flex flex-col justify-center items-center">
      <h1 className="text-6xl cursor-pointer sm:hidden">Phlote</h1>
      <div className="h-16"></div>
      <SearchBar placeholder="Search our archive" />
    </div>
  );
}

Home.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto max-h-max items-center flex-grow">
        {page}
      </div>
      <Footer />
    </Layout>
  );
};

export default Home;
