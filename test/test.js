const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Household", function () {

  describe("Add Members", function () {

    const SPECIAL = "0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c"
    const ALLOWED = "0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b"
    const NORMAL = "0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b"

    beforeEach(async function () {
      accounts = await ethers.getSigners();
      household_1_factory = await ethers.getContractFactory("HouseHold1");
      household1 = await household_1_factory.deploy();
    });

    // 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    // 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    // 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed

    it("Add a new member", async function () {
      await household1.addMember(NORMAL, accounts[1].address)
      expect(await household1.checkMember(NORMAL, accounts[1].address)).to.equal(true)
    });

    it("Add a new member by an unauthorized individual", async function () {
      await expect(household1.connect(accounts[7]).addMember(ALLOWED, accounts[9].address)).to.be.revertedWith("Not Authorized");
    });

    it

  });

  describe("Check & Remove Members", function () {

    const SPECIAL = "0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c"
    const ALLOWED = "0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b"
    const NORMAL = "0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b"

    beforeEach(async function () {
      accounts = await ethers.getSigners();
      household_1_factory = await ethers.getContractFactory("HouseHold1");
      household1 = await household_1_factory.deploy();
      await household1.addMember(NORMAL, accounts[7].address);
      await household1.addMember(SPECIAL, accounts[10].address);
      await household1.addMember(SPECIAL, accounts[15].address);
      await household1.addMember(ALLOWED, accounts[3].address);
    });

    // 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    // 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    // 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed

    it("Check if a member is part of the household", async function () {
      expect(await household1.checkMember(NORMAL, accounts[7].address)).to.equal(true)
    });

    it("Remove a NORMAL member by the CREATOR", async function () {
      await household1.removeMember(NORMAL, accounts[7].address)
      expect(await household1.checkMember(NORMAL, accounts[7].address)).to.equal(false)
    });

    it("Remove a SPECIAL member by a SPECIAL member", async function () {
      await household1.connect(accounts[10]).removeMember(SPECIAL, accounts[15].address)
      expect(await household1.checkMember(SPECIAL, accounts[15].address)).to.equal(false)
    });

    it("Remove a SPECIAL member by an ALLOWED member", async function () {
      await expect(household1.connect(accounts[3]).removeMember(SPECIAL, accounts[15].address)).to.be.revertedWith("Not Authorized")
    });
  });

  describe("Add Cryptos", function () {

    //ROLES
    const SPECIAL = "0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c"
    const ALLOWED = "0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b"
    const NORMAL = "0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b"

    //TOKENS - ADDRESSES FROM THE POLYGON BLOCKCHAIN
    const DAI = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"
    const WBTC = "0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6"
    const LINK = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"
    const BNB = "0x3BA4c387f786bFEE076A58914F5Bd38d668B42c3"
    const USDT = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"

    beforeEach(async function () {
      accounts = await ethers.getSigners();
      household_1_factory = await ethers.getContractFactory("HouseHold1");
      household1 = await household_1_factory.deploy();
      await household1.addMember(NORMAL, accounts[7].address);
      await household1.addMember(SPECIAL, accounts[10].address);
      await household1.addMember(SPECIAL, accounts[15].address);
      await household1.addMember(ALLOWED, accounts[3].address);
    });

    // 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    // 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    // 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed

    it("A SPECIAL member adds crypto to portfolio", async function () {
      await expect(household1.connect(accounts[15]).addCrypto(DAI)).to.be.revertedWith("Not Authorized")
    });

    it("An ALLOWED member adds crypto to portfolio", async function () {
      await household1.connect(accounts[3]).addCrypto(LINK)
      expect(await household1.checkCrypto(LINK)).to.equal(true)
    });

    it("CREATOR adds crypto to portfolio", async function () {
      await household1.addCrypto(BNB)
      expect(await household1.checkCrypto(BNB)).to.equal(true)
    });
  });

  describe("Remove Cryptos", function () {

    //ROLES
    const SPECIAL = "0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c"
    const ALLOWED = "0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b"
    const NORMAL = "0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b"

    //TOKENS - ADDRESSES FROM THE POLYGON BLOCKCHAIN
    const DAI = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"
    const WBTC = "0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6"
    const LINK = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"
    const BNB = "0x3BA4c387f786bFEE076A58914F5Bd38d668B42c3"
    const USDT = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"

    beforeEach(async function () {
      accounts = await ethers.getSigners();
      household_1_factory = await ethers.getContractFactory("HouseHold1");
      household1 = await household_1_factory.deploy();
      await household1.addMember(NORMAL, accounts[7].address);
      await household1.addMember(SPECIAL, accounts[10].address);
      await household1.addMember(SPECIAL, accounts[15].address);
      await household1.addMember(ALLOWED, accounts[3].address);
      await household1.addCrypto(WBTC);
      await household1.addCrypto(LINK);
      await household1.addCrypto(DAI);
      await household1.addCrypto(BNB);
      await household1.addCrypto(USDT);
    });

    // 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    // 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    // 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed

    it("A NORMAL member removes crypto from portfolio", async function () {
      await expect(household1.connect(accounts[7]).removeCrypto(DAI)).to.be.revertedWith("Not Authorized")
    });

    it("An ALLOWED member removes crypto from portfolio", async function () {
      await household1.connect(accounts[3]).removeCrypto(USDT)
      expect(await household1.checkCrypto(USDT)).to.equal(false)
    });

    it("A SPECIAL member removes crypto from portfolio", async function () {
      await expect(household1.connect(accounts[15]).removeCrypto(WBTC)).to.be.revertedWith("Not Authorized")
    });

    it("CREATOR removes crypto from portfolio", async function () {
      await household1.removeCrypto(LINK)
      expect(await household1.checkCrypto(LINK)).to.equal(false)
    });
  });
});

describe("Utility Provider", function () {

});
