// SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    constructor() ERC20("TokenA", "A") {
        uint256 MAX_INT = type(uint256).max;
        _mint(msg.sender, MAX_INT);
    }
}