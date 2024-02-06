const fs = require("fs");

async function main() {
  const factory = await ethers.getContractFactory("YourBrians");
  const contract = factory.attach("0x45ac82bC0f12553e5144e1dBf7dba3A02865Bbec");
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
