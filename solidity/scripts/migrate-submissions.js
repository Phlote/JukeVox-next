const { ethers } = require("hardhat");
const { createClient } = require("@supabase/supabase-js");

async function main() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  const supabase = createClient(supabaseUrl, supabaseAnonKey);

  const PhloteContractFactory = await ethers.getContractFactory("Phlote");
  const contract = await PhloteContractFactory.attach(
    process.env.RINKEBY_CONTRACT_ADDRESS
  );
  const submissions = await contract.getAllCurations();

  const sanitized = submissions.map((sub) => {
    const {
      id,
      submissionTime,
      mediaType,
      artistName,
      artistWallet,
      curatorWallet,
      mediaTitle,
      mediaURI,
      marketplace,
      tags,
    } = sub;

    return {
      id: id.toNumber(),
      mediaType,
      artistName,
      artistWallet,
      curatorWallet,
      mediaTitle,
      mediaURI,
      marketplace,
      tags,
      submissionTime: new Date(submissionTime.toNumber() * 1000).toISOString(),
    };
  });

  const insert = await supabase.from("submissions").insert(sanitized);
  console.log(insert);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
