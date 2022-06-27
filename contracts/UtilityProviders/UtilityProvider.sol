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
    uint64 private immutable startDate;
    uint256 private immutable fee;
    uint64 private constant duration = 2592000; // Duration for each payment will be done after 30 Days. Epoch- 2592000

    constructor(uint64 _startDate, uint256 _fee) {
        fee = _fee;
        startDate = _startDate;
    }

    /**
     * Register a new Household- Would rather not have this function with the "name" argument. However this is a requirement as
     * specified in the description. Storing strings in mapping is more expensive as a string can be of nlength.
     */
    function registerHousehold(address _household, string memory _name)
        external
        returns (bool)
    {
        registeredHouseholds[_household] = _name;
        bytes memory _nameStorageRef = bytes(registeredHouseholds[_household]);
        if (_nameStorageRef.length == 0) {
            return false;
        } else {
            dueDates[_household] = generateNewDueDate();
            emit HouseholdRegistered(_household, _name);
            return true;
        }
    }

    // Returns the fee specified for a particular utility provider
    function readFee() external view returns (uint256) {
        return fee;
    }

    /**
     * CalculateBillAmount- Calculates the billAmount for each household as per its due date.
     */
    function calculateBillAmount(address _household)
        internal
        view
        returns (uint256 balance, uint64 factor)
    {
        uint64 blockTimestamp = uint64(block.timestamp);
        uint64 dueDate = dueDates[_household];
        require(
            dueDate > 0,
            "No due date found for this household. Please register household first"
        );
        uint64 difference;
        if (blockTimestamp > dueDate) {
            difference = blockTimestamp - dueDate;
        } else if (blockTimestamp < dueDate) {
            difference = 0;
        }
        factor = (difference) / duration;
        if (difference != 0 && factor == 0) {
            balance = fee;
        } else {
            balance = fee * factor;
        }
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

    // Returns a due date for a particular household.
    function checkDueDate(address _household) external view returns (uint64) {
        return dueDates[_household];
    }

    // Calculates new due date based on the difference between the start date and current block timestamp
    function generateNewDueDate() private view returns (uint64) {
        uint64 blockTimestamp = uint64(block.timestamp);
        uint64 difference;
        require(
            blockTimestamp > startDate,
            "Cannot generate a new due date before the start date"
        );
        difference = blockTimestamp - startDate;
        uint64 factor = (difference) / duration;
        uint64 newDate = (startDate + duration) + (duration * factor);
        return newDate;
    }

    /*
     * Allows to pay the bill of a certain household. However, before the payment can be
     * processed the Utility Provider will verify with the household if the msg.sender is authorised
     * to pay the bill or not. Additionally, unpaid bills will still need to be paid if households miss their
     * due dates.
     */
    function billPayment(address _household) external virtual {
        (uint256 balance, uint64 factor) = _paymentRequired(_household);
        HouseHold(_household).verifyBillPayment(msg.sender, balance);
        dueDates[_household] += duration + (duration * factor); // Update due date to the latest
        emit BillPayed(_household, balance);
    }
}

// Interface for the HouseHold contract to use the verifyBillPayment function.
interface HouseHold {
    function verifyBillPayment(address _member, uint256 _balance) external;
}
