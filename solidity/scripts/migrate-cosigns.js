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

  const ids = [...Array(200).keys()];

  const promises = ids.map(async (id) => {
    const cosigns = await contract.getCosigns(id);
    if (cosigns && cosigns.length > 0) return { submissionId: id, cosigns };
  });

  const results = await (await Promise.all(promises)).filter((n) => n);

  const insert = await supabase.from("cosigns").insert(results);
  console.log(insert);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
