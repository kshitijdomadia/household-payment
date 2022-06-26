const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Household", function () {

  describe("Add Members", function () {
    /** ROLES
    * 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    * 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    * 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed
    */
    const SPECIAL = "0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c"
    const ALLOWED = "0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b"
    const NORMAL = "0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b"

    beforeEach(async function () {
      accounts = await ethers.getSigners();
      household_1_factory = await ethers.getContractFactory("HouseHold1");
      household1 = await household_1_factory.deploy();
    });

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
    /** ROLES
    * 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    * 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    * 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed
    */
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
    /** ROLES
    * 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    * 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    * 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed
    */
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

    /** ROLES
    * 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    * 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    * 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed
    */
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
  /** ROLES
  * 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
  * 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
  * 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed
  */
  const SPECIAL = "0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c"
  const ALLOWED = "0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b"
  const NORMAL = "0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b"

  beforeEach(async function () {
    //accounts
    accounts = await ethers.getSigners();

    //households
    household_1_factory = await ethers.getContractFactory("HouseHold1");
    household1 = await household_1_factory.deploy();
    household_2_factory = await ethers.getContractFactory("HouseHold2");
    household2 = await household_2_factory.deploy();
    household_3_factory = await ethers.getContractFactory("HouseHold3");
    household3 = await household_3_factory.deploy();

    //utility providers
    gas_factory = await ethers.getContractFactory("GasProvider");
    gas = await gas_factory.deploy();
    electricity_factory = await ethers.getContractFactory("ElectricityProvider");
    electricity = await electricity_factory.deploy();
    water_factory = await ethers.getContractFactory("WaterProvider");
    water = await water_factory.deploy();

    //member privileges
    await household1.addMember(NORMAL, accounts[7].address);
    await household2.addMember(SPECIAL, accounts[10].address);
    await household3.addMember(SPECIAL, accounts[15].address);
    await household2.addMember(ALLOWED, accounts[3].address);
  });

  it("Check Fee", async function () {
    expect(await gas.readFee()).to.equal("50000000000000000000")
  });

  it("Register a new House", async function () {
    await gas.registerHousehold(household2.address, "Mumbai")
    expect(await gas.checkDueDate(household2.address)).to.equal(1656547200)
  });

  it("Check if Payment is required for a non-registered house", async function () {
    await expect(electricity.paymentRequired(household2.address)).to.be.revertedWith("No due date found for this household. Please register household first")
  });

  it("Check if Payment is required for a registered house", async function () {
    await water.registerHousehold(household3.address, "Seoul")
    await water.checkDueDate(household3.address)
    await ethers.provider.send("evm_mine", [1656720000]); // fast forward time
    //Fees required for a months worth of water utilities -- Water Providers charge $85
    expect((await water.paymentRequired(household3.address)).balance).to.be.equal("85000000000000000000")
  });

  it("Check if Payment is required for a registered house after 4 months", async function () {
    await gas.registerHousehold(household1.address, "Dubai")
    dueDate = await gas.checkDueDate(household1.address)
    await ethers.provider.send("evm_mine", [Number(dueDate) + 10368000]); // fast forward time to 4 months
    //Fees required for 4 months worth of gas utilities -- Gas Providers take a fee of $50
    expect((await gas.paymentRequired(household1.address)).balance).to.be.equal("200000000000000000000")
  });

  it("Unauthorised Person pays the Bill", async function () {
    await water.registerHousehold(household3.address, "Seoul")
    await expect(water.connect(accounts[17]).billPayment(household3.address)).to.be.revertedWith("You're not an authorised member to pay the bill")
  });

  it("Authorized Person pays the Bill", async function () {
    await electricity.registerHousehold(household2.address, "Miami")
    await ethers.provider.send("evm_mine", [Number(dueDate) + 31104000]); // fast forward time to 12 months
    expect(await electricity.connect(accounts[3]).billPayment(household2.address)).to.be.emit("BillPayed")
  });
});
