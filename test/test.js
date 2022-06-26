const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Household Functions", function () {

  const SPECIAL="0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c"
  const ALLOWED="0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b"
  const NORMAL="0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b"

  beforeEach(async function () {
    accounts = await ethers.getSigners();
    household_1_factory = await ethers.getContractFactory("HouseHold1");
    household1 = await household_1_factory.deploy();
  });

  // 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
  // 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
  // 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed

  it("Add a new member", async function () {
    household1.addMember(NORMAL, accounts[1].address)
    
  });

});
