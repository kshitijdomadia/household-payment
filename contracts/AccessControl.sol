//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

abstract contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) public roles;

    /**
     * Avoiding _CREATOR to be hashed for security reasons. Will NOT be as cheaper as storing Bytes32 but avoids
     * attacker to purposefully become the "_CREATOR" of the contract by granting themselves _CREATOR rights by
     * using the _CREATOR hash.
     */
    address private immutable _CREATOR;
    // 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    bytes32 internal constant SPECIAL = keccak256(abi.encodePacked("SPECIAL"));
    // 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    bytes32 internal constant ALLOWED = keccak256(abi.encodePacked("ALLOWED"));

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "Not Authorized");
        _;
    }

    constructor() {
        _CREATOR = msg.sender;
        grantRole(SPECIAL, msg.sender);
        grantRole(ALLOWED, msg.sender);
    }

    function grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) internal {
        require(!(_account == _CREATOR), "Cannot revoke the Creator and their privileges");
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }
}
