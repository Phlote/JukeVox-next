import { useRouter } from "next/router";
import { HomeLayout } from "../components/Layouts";
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
    <HomeLayout>
      <SearchBar placeholder="Search our archive" />
    </HomeLayout>
  );
}

export default Home;
