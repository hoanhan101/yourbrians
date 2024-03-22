const path = require("path");
const fs = require("fs");
const utils = require("./utils");

async function main() {
  const addresses = {
    hardhat: "0x9A9f2CCfdE556A7E9Ff0848998Aa4a0CFD8863AE",
    sepolia: "0x8027db0d7bda7bd428a06be32305eb52fd0ebea5",
    mainnet: "0xcdfcf5dbe963282ec31b71c1976e41c4ffe42652",
  };
  const contract = await getContract(addresses.sepolia);
  await updateImg(contract);
}

const getContract = async (address) => {
  const factory = await ethers.getContractFactory("YourBrians");
  const contract = factory.attach(address);
  console.log(await contract.name());
  return contract;
};

const updateImg = async (contract) => {
  const img = utils.blitmapEncode(
    path.join(__dirname, "../assets/yourbrian_mutiply.svg")
  );
  console.log(img);
  await contract.uploadArt(img);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
