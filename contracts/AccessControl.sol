//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

abstract contract AccessControl {
    event GrantRoles(bytes32[2] indexed roles, address indexed account);
    event GrantRole(bytes32 indexed role, address indexed account);
    event GrantOwnership(address indexed account);
    event RevokeRoles(bytes32[2] indexed roles, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) internal roles;

    /**
     * Avoiding _CREATOR to be hashed for security reasons. Will NOT be as cheaper as storing Bytes32 but avoids
     * attacker to purposefully become the "_CREATOR" of the contract by granting themselves _CREATOR rights by
     * using the _CREATOR hash.
     */
    address private _CREATOR;
    // 0xe0a0f7a45cdcd35098a308bfc1687a7d925dd1a3e120f49caa703614ff21847c  - Bytes32 if "SPECIAL" is packed
    bytes32 internal constant SPECIAL = keccak256(abi.encodePacked("SPECIAL"));
    // 0x4a480454dcdcf9c032ac1b5db36b6df0bffc2c4b4887d1b7314ce196d5080e4b - Bytes32 if "ALLOWED" is packed
    bytes32 internal constant ALLOWED = keccak256(abi.encodePacked("ALLOWED"));
    // 0x34830a28f0d3ce3b9864e814bfc0a83461a67ccd50b181c9b501c368503d779b - Bytes32 if "NORMAL" is packed
    bytes32 internal constant NORMAL = keccak256(abi.encodePacked("NORMAL"));

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "Not Authorized");
        _;
    }

    constructor() {
        _CREATOR = msg.sender;
        grantRole(SPECIAL, msg.sender); //SPECIAL is only a place holder as the grantRole gives all privileges to the Owner
    }

    function grantRole(bytes32 _role, address _account) internal {
        if (_account == _CREATOR) {
            roles[SPECIAL][_account] = true;
            roles[ALLOWED][_account] = true;
            roles[NORMAL][_account] = true;
            emit GrantOwnership(_account);
        } else if (_role == SPECIAL || _role == ALLOWED) {
            roles[_role][_account] = true;
            roles[NORMAL][_account] = true;
            emit GrantRoles([_role, NORMAL], _account);
        } else if (_role == NORMAL) {
            roles[_role][_account] = true;
            emit GrantRole(_role, _account);
        }
    }

    function revokeRole(bytes32 _role, address _account) internal {
        require(
            !(_account == _CREATOR),
            "Cannot revoke the Creator and their privileges"
        );
        if (_role == SPECIAL || _role == ALLOWED) {
            roles[_role][_account] = false;
            roles[NORMAL][_account] = false;
            emit RevokeRoles([_role, NORMAL], _account);
        } else if (_role == NORMAL) {
            roles[_role][_account] = false;
            emit RevokeRole(_role, _account);
        }
    }
}
