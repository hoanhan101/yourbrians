const fs = require("fs");

async function main() {
  const factory = await ethers.getContractFactory("YourBrians");
  const contract = factory.attach("0xCDFCF5dbe963282ec31B71C1976e41c4FFe42652");
  console.log(await contract.name());
  console.log(await contract.totalSupply());

  await contract.setSender("0x59F61A131AA1BE988B5562504D94E54ee84Eab92");

  //   await contract.airdrop(
  //     ["00ff00", "ff00ff"],
  //     "0xd1b2672DFFF019efbA2b2056F64AF65BB30B077D"
  //   );

  //   console.log(await contract.totalSupply());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
