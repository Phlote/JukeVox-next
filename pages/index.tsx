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
      <div className="sm:hidden text-center mx-4">
        <h1 className="text-6xl">Phlote</h1>
        <div className="h-16"></div>
        <p>Help us save talented artists from being lost on the internet.</p>
        <br />
        <p>Submit the music of your favorite independent artists.</p>
      </div>

      <div className="hidden sm:block">
        <SearchBar placeholder="Search our archive" />
      </div>
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
