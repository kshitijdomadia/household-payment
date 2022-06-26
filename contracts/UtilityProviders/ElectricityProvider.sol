//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "./UtilityProvider.sol";

contract ElectricityProvider is UtilityProvider {
    /**
     * 1)
     * 15th of May 2022: Epoch- 1652572800
     * The constructor takes in the argument as the Epoch timestamp for the "Start Date".
     * 2)
     * $130 will be the fee payment for each invoice
     */
    constructor() UtilityProvider(1652572800, 130000000000000000000) {}
}
