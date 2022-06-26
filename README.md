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

1. The automation for the bill payments is unfortunately not technically feasible to be done implicitly by EVM and can be achieved by the likes of [Gelato](https://www.gelato.network) and/or [EPNS](https://epns.io)

> Hence, the offchain script offers a "mock" of how payments can be automated.

2. There is a mapping for cryptocurrencies for the portfolio. However, there is no selection of a "best" crypto for utility payments. As there is no clear definition of "best", we may have following theories for what it means:
- A token that is easily liquidable (Has a pair with one of the stable coins)
- A token that has mooned (1 Token= $100,000)? :exploding_head:
- Enough balance for paying utilities/other things.

>A simple solution for this would be to go target the easily liquidable tokens that have a pair with one of the stable coins by querying the 'getPair' of the DEX factory address and simply add the Utility Providers Address in the 'to' column!

```solidity
function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,                     <--- Add here!
        uint deadline
    ) external returns (uint[] memory amounts);
```

# Test Cases

![Test Cases](/assets/images/TestCases.png)
