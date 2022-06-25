//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "./UtilityProvider.sol";

contract ElectricityProvider is UtilityProvider {
    constructor() {
        fee = 130000000000000000000; // $130 will be the fee payment for each invoice
    }
}
