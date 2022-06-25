//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

abstract contract UtilityProvider {
    uint256 internal fee; // $130 will be the fee payment for each invoice

    // Register a new Household
    function registerHousehold(address household, string memory name)
        external
        virtual
        returns (bool);

    // Check if the payment is required and how much
    function paymentRequired(address household)
        external
        virtual
        returns (uint256);
}
