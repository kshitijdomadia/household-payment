# Household Payment (A project built on Solidity)

## Problem Statement ⚡🔥💦

Every month, a household has to pay their bills (electricity, gas, and water) to their utility providers. Utility providers accept only one type of stable coin as payment. The household would like to use its cryptocurrency portfolio to pay for its utilities. Household members would prefer if everything happens automatically, but they do not mind being reminded about the payment before it is too late. The most important thing for them is that the solution would select automatically among their portfolio cryptocurrencies and use the best one for payment.

## Project Description 📄

The goal is to implement a solution using Solidity to enable households to pay automatically for their utility bills with their cryptocurrency portfolio.

- Household has to be registered at every utility provider.
    
    ```solidity
    function registerHousehold(address household, string memory name) external returns (bool);
    ```
    
    - `household` is an address of deployed smart contract.
    - `name` is a unique string that allows utility provider to know where you live.
    - returns `true` if registration proceeded successfully, otherwise returns `false`
- Household’s cryptocurrency portfolio is held inside of smart contract.
- Every household member can add new household member.
- Only special household members can remove other members (including other special members).
- Only **allowed** household members can add or remove cryptocurrencies from household’s portfolio.
- Only **allowed** household members can pay for household’s utility bills.
- Creator (both special and **allowed** implicitly) of household cannot be removed from household and cannot be denied payment for utilities (always **allowed**).
- All utility (electricity, gas, and water) providers require the payment before the certain date which is different for each provider, but same every month.
- You can find out about the required payment from each utility provider by calling their smart contract.
    
    ```solidity
    function paymentRequired(address household) external returns (uint256);
    ```
    
    - `household` is an address of deployed smart contract.
    - returns the amount of stable coin that needs to be paid

**NOTE:** The description was laid down with basic assumptions. The code might reflect a few differences that may not match with the description entirely.

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

**IMPORTANT NOTICE:** This idea has been implemented in branch ```router-interact``` without the offchain-script.js and test.js implementation.

# Test Cases

![Test Cases](/assets/images/TestCases.png)
