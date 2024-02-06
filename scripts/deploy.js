const path = require("path");
const fs = require("fs");
const hre = require("hardhat");
const utils = require("./utils");

const { expect } = require("chai");

const TMP_ASSETS_DIR = "./test/assets";

if (!fs.existsSync(TMP_ASSETS_DIR)) {
  fs.mkdirSync(TMP_ASSETS_DIR);
}

async function main() {
  //
  // SETUP
  //
  const contractName = "YourBrians";
  const contractSymbol = "URBR";
  const contractSupply = 1337;

  const contract = await (
    await ethers.getContractFactory(contractName)
  ).deploy(contractName, contractSymbol, contractSupply);
  await contract.waitForDeployment();
  const contractAddress = await contract.getAddress();
  console.log("DEPLOYED CONTRACT", contractAddress);

  const img = utils.blitmapEncode(path.join(__dirname, "../assets/brian.svg"));
  console.log(img);

  await contract.uploadArt(img);

  //
  // TEST LOCALLY
  //
  if (hre.network.name == "localhost") {
    expect(await contract.totalSupply()).to.equal(0);

    const testSupply = 3;
    for (let i = 0; i < testSupply; i++) {
      const [owner, addr1, addr2] = await ethers.getSigners();
      if (i === 0) {
        await contract.airdrop(utils.randomColors(), addr1.address);
        await contract.setSender(addr1.address);
      } else {
        await contract.connect(addr1).send(utils.randomColors(), owner.address);

        await expect(
          contract.connect(addr2).send(utils.randomColors(), owner.address)
        ).to.be.revertedWithCustomError(contract, "InvalidSender");
      }

      const tokenURI = await contract.tokenURI(i);
      const payload = JSON.parse(tokenURI.split("data:application/json,")[1]);

      console.log(i, payload);
      fs.writeFileSync(
        path.join(TMP_ASSETS_DIR, `${i}.svg`),
        atob(payload.image.split("data:image/svg+xml;base64,")[1])
      );
    }

    expect(await contract.totalSupply()).to.equal(testSupply);
  }

  //
  // VERYFI ON BASESCAN
  //
  if (
    hre.network.name == "base-sepolia" ||
    hre.network.name == "base-mainnet"
  ) {
    console.log("VERIFYING ON BASESCAN");
    await utils.delay(30000);

    await hre.run("verify:verify", {
      address: contractAddress,
      constructorArguments: [contractName, contractSymbol, contractSupply],
    });
    console.log("VERIFED ON BASESCAN");
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
