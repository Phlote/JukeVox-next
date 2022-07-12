Moralis.Cloud.define("mintOnZora", async (request) => {
  web3 = new Moralis.Web3(
    new Moralis.Web3.providers.HttpProvider(
      "https://mainnet.infura.io/v3/7536042cc02045b28fd2219ae2285419"
    )
  );
  const abi = [
    {
      constant: true,
      inputs: [],
      name: "name",
      outputs: [{ name: "", type: "string" }],
      payable: false,
      stateMutability: "view",
      type: "function",
    },
  ];
  // DAI Stablecoin on eth
  address = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
  const contract = new web3.eth.Contract(abi, address);
  const name = await contract.methods
    .name()
    .call()
    .catch((e) => logger.error(`callName: ${e}${JSON.stringify(e, null, 2)}`));
  return name;
});
