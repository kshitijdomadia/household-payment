//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "./UtilityProvider.sol";

contract WaterProvider is UtilityProvider {
    constructor() {
        fee = 85000000000000000000; // $85 will be the fee payment for each invoice
    }
}
