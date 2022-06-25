//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

abstract contract UtilityProvider {
    event BillPayed(address indexed household, uint256 indexed amount);

    uint256 internal fee; // $130 will be the fee payment for each invoice

    // Register a new Household
    function registerHousehold(address _household, string memory _name)
        external
        virtual
        returns (bool)
    {}

    // Check if the payment is required and how much
    function paymentRequired(address _household)
        external
        virtual
        returns (uint256)
    {}

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
