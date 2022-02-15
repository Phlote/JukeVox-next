import React from "react";
import Image from "next/image";
import { HollowInput, HollowInputContainer } from "../components/Hollow";
import { HomeLayout } from "../components/Layouts";

function Home() {
  return (
    <HomeLayout>
      <div className="w-3/4 h-16" style={{ lineHeight: "0.5rem" }}>
        <HollowInputContainer
          onClick={() => {
            document.getElementById("search-home").focus();
          }}
        >
          <Image height={30} width={30} src="/search.svg" alt="search" />
          <HollowInput
            id="search-home"
            className="ml-4 flex-grow"
            type="text"
            placeholder="Search coming soon!"
          />
        </HollowInputContainer>
      </div>
    </HomeLayout>
  );
}

export default Home;
