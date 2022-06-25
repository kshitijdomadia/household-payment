//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "../AccessControl.sol";

abstract contract HouseHold is AccessControl {
    event AddedCrypto(address indexed token, address indexed account);
    event RemovedCrypto(address indexed token, address indexed account);

    mapping(address => bool) public cryptos;

    // Will add a member to the household
    function addMember(bytes32 _role, address _account)
        external
        virtual
        onlyRole(SPECIAL)
    {
        grantRole(_role, _account);
    }

    // Will remove a member of the household. Can only be done if it's a SPECIAL OR OWNER/CREATOR of this Household contract
    function removeMember(bytes32 _role, address _account)
        external
        virtual
        onlyRole(SPECIAL)
    {
        revokeRole(_role, _account);
    }

    // Allow adding desired crypto currencies to the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function addCrypto(address _token) external virtual onlyRole(ALLOWED) {
        cryptos[_token] = true;
        emit AddedCrypto(_token, msg.sender);
    }

    // Allows removing desired crypto currencies from the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function removeCrypto(address _token) external virtual onlyRole(ALLOWED) {
        cryptos[_token] = false;
        emit RemovedCrypto(_token, msg.sender);
    }

    // Allows to pay the utility bill for one of the providers ONLY by an ALLOWED or OWNER/CREATOR of this Household contract
    function payBill(address utiliyProvider, uint256 amount)
        external
        virtual
        onlyRole(ALLOWED)
    {}
}
