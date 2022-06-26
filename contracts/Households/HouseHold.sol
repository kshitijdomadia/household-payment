//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "../AccessControl.sol";

abstract contract HouseHold is AccessControl {
    event AddedCrypto(address indexed token, address indexed account);
    event RemovedCrypto(address indexed token, address indexed account);

    mapping(address => bool) private cryptos;

    // Will add a member to the household
    function addMember(bytes32 _role, address _account)
        external
        onlyRole(NORMAL)
    {
        grantRole(_role, _account);
    }

    // Will check if a member exists in the household with a role -- Internal visibility for gas savings
    function _checkMember(bytes32 _role, address _account)
        internal
        view
        returns (bool)
    {
        if ((roles[_role][_account]) == true) {
            return true;
        } else {
            return false;
        }
    }

    // Will check if a member exists in the household with a role
    function checkMember(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return _checkMember(_role, _account);
    }

    // Will check if a crypto exists in the household portfolio -- Internal visibility for gas savings
    function _checkCrypto(address token) internal view returns (bool) {
        if ((cryptos[token]) == true) {
            return true;
        } else {
            return false;
        }
    }

    // Will check if a crypto exists in the household portfolio
    function checkCrypto(address token) external view returns (bool) {
        return _checkCrypto(token);
    }

    // Will remove a member of the household. Can only be done if it's a SPECIAL OR OWNER/CREATOR of this Household contract
    function removeMember(bytes32 _role, address _account)
        external
        onlyRole(SPECIAL)
    {
        revokeRole(_role, _account);
    }

    // Allow adding desired crypto currencies to the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function addCrypto(address _token) external onlyRole(ALLOWED) {
        cryptos[_token] = true;
        emit AddedCrypto(_token, msg.sender);
    }

    // Allows removing desired crypto currencies from the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function removeCrypto(address _token) external onlyRole(ALLOWED) {
        cryptos[_token] = false;
        emit RemovedCrypto(_token, msg.sender);
    }

    // Allows to pay the utility bill for one of the providers ONLY by an ALLOWED or OWNER/CREATOR of this Household contract
    function verifyBillPayment(address _member) external view returns (bool) {
        require(
            _checkMember(ALLOWED, _member),
            "You're not an authorised member to pay the bill"
        );
        return true;
    }
}
