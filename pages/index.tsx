import React from "react";
import Image from "next/image";
import { HollowInput, HollowInputContainer } from "../components/Hollow";
import { HomeLayout } from "../components/Layouts";
import { useKeyPress } from "../hooks/useKeyPress";
import { useRouter } from "next/router";
import { SearchBar, useSearchTerm } from "../components/SearchBar";

function Home() {
  const [searchTerm, setSearchTerm] = useSearchTerm();
  const router = useRouter();

  useKeyPress("Enter", () => {
    if (!!searchTerm && searchTerm.length > 0) {
      router.push("/archive");
    }
  });

  return (
    <HomeLayout>
      <SearchBar placeholder="Search our archive" />
    </HomeLayout>
  );
}

export default Home;
