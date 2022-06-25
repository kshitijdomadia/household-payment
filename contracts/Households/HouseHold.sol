//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

abstract contract HouseHold {
    // Will add a member to the household
    function addMember() virtual external;

    // Will remove a member of the household. Can only be done if it's a SPECIAL OR OWNER/CREATOR of this Household contract
    function removeMember() virtual external;

    // Allow adding desired crypto currencies to the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function addCrypto() virtual external;

    // Allows removing desired crypto currencies from the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function removeCrypto() virtual external;

    // Allows to pay the utility bill for one of the providers ONLY by an ALLOWED or OWNER/CREATOR of this Household contract
    function payBill(address utiliyProvider, uint256 amount) virtual external;
}
