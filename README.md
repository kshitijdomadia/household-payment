# Bisonai Household Payment

## Project Description
The project was made as per the instructions lined out by the Bisonai team [here](https://bisonai.notion.site/Blockchain-Software-Developer-d518215286b3480ab9fadf03532cd3fb)
## Brain Dump :brain:
![Bisonai Description](/assets/images/Bisonai_Description_Map.png)

## Installation

Use [git](https://git-scm.com) to clone this repository in your desired location.

```bash
git clone https://github.com/kshitijdomadia/household-payment.git
```

Within the directory. Use the package manager [npm](https://www.npmjs.com) to install dependencies for the project.

```bash
npm install
```

## Usage
To run the offchain-script.
```bash
npx hardhat run scripts/offchain-script.js
```
To run the test cases.
```bash
npx hardhat test
```

## Summary and Breakdown of the project

The project has been created with a few basic assumptions in mind.

1. The automation for the bill payments is unfortunately not technically feasible to be done implicitly by EVM but can be achieved by the likes of [Gelato](https://www.gelato.network) and/or [EPNS](https://epns.io)

> Hence, the offchain script offers a "mock" of how payments can be automated. However, this may **not** be suitable for production environment.

2. There is a mapping for cryptocurrencies for the portfolio. However, there is no selection of a "best" token for utility payments included in the project. We may have following theories for what a "best" token can be:
- A token that is easily liquidable (Has a pair with one of the stable coins)
- A token that has mooned (1 Token= $100,000)? :exploding_head:
- Enough balance for paying utilities/other things.

> A simple solution for this would be to go target the easily liquidable tokens that have a pair with one of the stable coins (That the provider accepts) while the household member also has sufficient balance to make the swap and payment simultaneously. By querying the ```getPair``` of the DEX factory address to confirm the pair and simply adding the Utility Providers Address in the 'to' column while making the payment, we can automate the process of paying the utility bill with a non-stable coin **within** the smart contract.

```solidity
function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,                     <--- Add here!
        uint deadline
    ) external returns (uint[] memory amounts);
```
Once the utility provider receives the payment it can emit the ```BillPayed``` event to signal that the payment has been received.

**IMPORTANT NOTICE:** This idea has been implemented in branch ```router-interact``` without the offchain-script.js and test.js.

# Test Cases

![Test Cases](/assets/images/TestCases.png)
