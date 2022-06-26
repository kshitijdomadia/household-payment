//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "./UtilityProvider.sol";

contract WaterProvider is UtilityProvider {
    /**
     * 1)
     * 30th of May 2022: Epoch- 1653868800
     * The constructor takes in the argument as the Epoch timestamp for the "Start Date".
     * 2)
     * $85 will be the fee payment for each invoice
     */
    constructor() UtilityProvider(1653868800, 85000000000000000000) {}
}
