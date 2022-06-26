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

  /**
   * This script is meant to "mock" and autonomous off-chain script that continuously checks if the
   * bill requires payment. If it does, it pays off the bill and continues to check and advance in time (For simplicity sake).
   * This script will mock for 1 utility provider for a particular household. The same can be extensive for other
   * providers and household.
   */

  //Accounts
  accounts = await ethers.getSigners();

  //households
  household_factory = await ethers.getContractFactory("HouseHold1");
  household = await household_factory.deploy();

  console.log({ HouseHoldAddress: household.address })

  //utility providers
  gas_factory = await ethers.getContractFactory("GasProvider");
  gas = await gas_factory.deploy();

  console.log({ GasProviderAddress: gas.address })

  register = await gas.registerHousehold(household.address, "Mumbai")
  registerRcpt = await register.wait()

  while (true) {
    try {
      tx = await gas.billPayment(household.address)
      txReceipt = await tx.wait()
      if (txReceipt.status == 1) {
        console.log("Bill Payed! Fast Forwarding Time by >>>>>> 10 Days")
        const latestBlock = await hre.ethers.provider.getBlock("latest")
        await ethers.provider.send("evm_mine", [latestBlock.timestamp + 864000]);
      }
    } catch (error) {
      console.log("Exception Caught. Fast Forwarding Time by >>>>>> 5 Days")
      const latestBlock = await hre.ethers.provider.getBlock("latest")
      await ethers.provider.send("evm_mine", [latestBlock.timestamp + 432000]);
    }
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
