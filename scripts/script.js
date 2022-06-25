// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Gas = await hre.ethers.getContractFactory("GasProvider");
  const gas = await Gas.deploy();

  const gasReceipt = await gas.deployed();

  console.log("GasContract deployed to:", gas.address);

  const registration = await gas.registerHousehold("0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc", "Mumbai")
  const readRegistration = await gas.readHouseholds("0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc")
  const readRegistration2 = await gas.readHouseholds("0x2546BcD3c84621e976D8185a91A922aE77ECEc30")

  // console.log(readRegistration)
  // console.log(readRegistration2)

  //const receipt = await readRegistration.wait();
  //const receipt2 = await readRegistration2.wait();

  // console.log(receipt)
  // console.log(receipt2)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
