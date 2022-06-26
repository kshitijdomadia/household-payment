//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "./UtilityProvider.sol";

contract GasProvider is UtilityProvider {
    /**
     * 1)
     * 1st of May 2022: Epoch- 1651363200
     * The constructor takes in the argument as the Epoch timestamp for the "Start Date".
     * 2)
     * $50 will be the fee payment for each invoice
     */
    constructor()
        UtilityProvider(1651363200, 50000000000000000000, address(this))
    {}
}
