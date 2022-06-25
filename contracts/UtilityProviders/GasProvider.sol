//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "./UtilityProvider.sol";

contract GasProvider is UtilityProvider {
    constructor(){
        fee = 50000000000000000000; // $50 will be the fee payment for each invoice
    }
}
