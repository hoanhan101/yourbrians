const fs = require("fs");

async function main() {
  const factory = await ethers.getContractFactory("YourBrians");
  const contract = factory.attach("0xfab01331fA193e8e2E690488E79B38bcd5A584A9");
  console.log(await contract.name());
  console.log(await contract.totalSupply());

  await contract.airdrop(
    ["00ff00", "ff00ff"],
    "0xd1b2672DFFF019efbA2b2056F64AF65BB30B077D"
  );

  console.log(await contract.totalSupply());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
