//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

abstract contract HouseHold {
    // Will add a member to the household
    function addMember() external virtual {}

    // Will remove a member of the household. Can only be done if it's a SPECIAL OR OWNER/CREATOR of this Household contract
    function removeMember() external virtual {}

    // Allow adding desired crypto currencies to the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function addCrypto() external virtual {}

    // Allows removing desired crypto currencies from the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function removeCrypto() external virtual {}

    // Allows to pay the utility bill for one of the providers ONLY by an ALLOWED or OWNER/CREATOR of this Household contract
    function payBill(address utiliyProvider, uint256 amount) external virtual {}
}
