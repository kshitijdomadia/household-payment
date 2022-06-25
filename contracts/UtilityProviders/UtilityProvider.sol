//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "hardhat/console.sol";

abstract contract UtilityProvider {
    event BillPayed(address indexed householdAddress, uint256 indexed amount);
    event HouseholdRegistered(
        address indexed householdAddress,
        string indexed name
    );

    mapping(address => string) private registeredHouseholds;
    mapping(address => uint256) private balances;
    uint256 internal fee;

    // Register a new Household
    function registerHousehold(address _household, string memory _name)
        external
        virtual
        returns (bool)
    {
        registeredHouseholds[_household] = _name;
        bytes memory _nameStorageRef = bytes(registeredHouseholds[_household]);
        if (_nameStorageRef.length == 0) {
            return false;
        } else {
            emit HouseholdRegistered(_household, _name);
            return true;
        }
    }

    function readHouseholds(address _household) external virtual {
        bytes memory test = bytes(registeredHouseholds[_household]);
        if (test.length == 0) {
            console.log("String is zero!");
        } else {
            console.log(string(test));
        }
    }

    // Check if the payment is required and how much
    function paymentRequired(address _household)
        external
        virtual
        returns (uint256)
    {
        return balances[_household];
    }

    /*
     *Allows to pay the bill of a certain household. However, before the payment can be
     *processed the Utility Provider will verify with the household if the msg.sender is authorised
     *to pay the bill or not.
     */
    function billPayment(address _household, uint256 _amount) external virtual {
        HouseHold(_household).verifyBillPayment(msg.sender);
        emit BillPayed(_household, _amount);
    }
}

interface HouseHold {
    function verifyBillPayment(address _member) external;
}
