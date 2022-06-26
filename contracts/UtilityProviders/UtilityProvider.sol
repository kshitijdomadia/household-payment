//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "hardhat/console.sol";

abstract contract UtilityProvider {
    event BillPayed(address indexed householdAddress, uint256 indexed amount);
    event HouseholdRegistered(
        address indexed householdAddress,
        string indexed name
    );

    mapping(address => string) private registeredHouseholds; // Would rather not have this mapping. However this is a requirement as specified in the description.
    mapping(address => uint64) private dueDates;
    uint256 private immutable fee;
    uint64 private immutable startDate; // Due date for each provider will be ~ at the same date every month
    uint64 private constant duration = 2592000; // Duration for each payment will be done after 30 Days. Epoch- 2592000

    constructor(
        uint64 _startDate,
        uint256 _fee,
        address _household
    ) {
        startDate = _startDate;
        fee = _fee;
        dueDates[_household] = _startDate + duration;
    }

    // Register a new Household- Would rather not have this function. However this is a requirement as specified in the description.
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

    function readFee() external view returns (uint256) {
        return fee;
    }

    function calculateBillAmount(address _household)
        internal
        view
        returns (uint256 balance, uint64 factor)
    {
        uint64 blockTimestamp = uint64(block.timestamp);
        uint64 dueDate = dueDates[_household];
        uint64 difference;
        if (blockTimestamp > dueDate) {
            difference = blockTimestamp - dueDate;
        } else if (blockTimestamp < dueDate) {
            difference = 0;
        }
        factor = (difference) / duration;
        balance = fee * factor;
        return (balance, factor);
    }

    // Check if the payment is required and how much
    function paymentRequired(address _household)
        external
        view
        returns (uint256 balance, uint64 factor)
    {
        return _paymentRequired(_household);
    }

    // Check if the payment is required and how much- Internal for gas savings and internal calls.
    function _paymentRequired(address _household)
        internal
        view
        returns (uint256 balance, uint64 factor)
    {
        (balance, factor) = calculateBillAmount(_household);
        require(
            balance > 0,
            "Nothing to pay yet. However, kindly check your due date using checkDueDate()"
        );
        return (balance, factor);
    }

    function checkDueDate(address _household) external view returns (uint64) {
        return dueDates[_household];
    }

    /*
     *Allows to pay the bill of a certain household. However, before the payment can be
     *processed the Utility Provider will verify with the household if the msg.sender is authorised
     *to pay the bill or not.
     */
    function billPayment(address _household) external virtual {
        HouseHold(_household).verifyBillPayment(msg.sender);
        (uint256 balance, uint64 factor) = _paymentRequired(_household);
        dueDates[_household] += duration * factor; // Update due date to the latest
        emit BillPayed(_household, balance);
    }
}

interface HouseHold {
    function verifyBillPayment(address _member) external;
}
