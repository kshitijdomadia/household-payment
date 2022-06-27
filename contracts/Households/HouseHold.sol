//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "../AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../DEX_Interfaces/IFactory.sol";
import "../DEX_Interfaces/IRouter.sol";

abstract contract HouseHold is
    AccessControl,
    IERC20,
    ReentrancyGuard,
    IUniswapV2Factory,
    IUniswapV2Router02
{
    event AddedCrypto(address indexed token, address indexed account);
    event RemovedCrypto(address indexed token, address indexed account);

    address immutable factory = 0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32;
    address immutable router = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
    mapping(address => bool) private cryptos;
    address[] private cryptosStorage;

    constructor(address _stableCoin, address _otherToken) {
        cryptos[_stableCoin] = true;
        cryptos[_otherToken] = true;
        cryptosStorage[0] = _stableCoin; //Assuming a stable coin is always stored in first index.
        cryptosStorage[1] = _otherToken; //Assuming all other non-stable tokens are stored after index 0.
    }

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
        cryptosStorage.push(_token);
        cryptos[_token] = true;
        emit AddedCrypto(_token, msg.sender);
    }

    // Allows removing desired crypto currencies from the households portfolio. Can only be done if it's a ALLOWED OR OWNER/CREATOR of this Household contract
    function removeCrypto(address _token) external onlyRole(ALLOWED) {
        // No need to remove the crypto from the array as the mapping will indicate that the crypto does not exist in portfolio.
        cryptos[_token] = false;
        emit RemovedCrypto(_token, msg.sender);
    }

    // Here the best crypto is selected and typically finalizes the payment
    function _selectCrypto(address _member, uint256 _amount)
        private
        returns (bool)
    {
        // First priority would be to check if a stablecoin exists. If he/she does, does the msg.sender have sufficient balance?
        // Knowing that stablecoin is stored in 0th position in the array, check if it exists in the portfolio.
        if (cryptos[cryptosStorage[0]] == true) {
            IERC20 USDT = IERC20(cryptosStorage[0]);
            uint256 USDTBalance = USDT.balanceOf(_member);
            if (USDTBalance >= 0) {
                USDT.transferFrom(_member, msg.sender, _amount);
                return true;
            } else {
                uint256 length = cryptosStorage.length;
                for (uint256 i = 1; i < length; i++) {
                    if (cryptos[cryptosStorage[i]] == true) {
                        address stableCoin = cryptosStorage[0];
                        address token = cryptosStorage[i];
                        IERC20 TOKEN = IERC20(cryptosStorage[i]);
                        // The list will invert the addresses so that the correct getAmountsOut is returned. ie. 1 Token = $x
                        address[] memory cryptoList = new address[](2);
                        cryptoList[0] = token;
                        cryptoList[1] = stableCoin;
                        // Check if the token has a pair with a stable coin
                        address pairAddress = IUniswapV2Factory(factory)
                            .getPair(cryptoList[0], cryptoList[1]);
                        if (pairAddress != address(0)) {
                            uint256 tokenBalance = TOKEN.balanceOf(_member);
                            if (tokenBalance >= 0) {
                                IUniswapV2Router02 Router = IUniswapV2Router02(
                                    router
                                );
                                //  If the payee has tokens, ie. > 0. The tokens are checked if they are sufficient enough to be used to pay the bill for the provider.
                                uint256[] memory amounts = Router.getAmountsOut(
                                    tokenBalance,
                                    cryptoList
                                );
                                // if $x > billAmount then proceed with the swap and payment.
                                if (amounts[1] > _amount) {
                                    address[] memory tokenPath = new address[](
                                        2
                                    );
                                    tokenPath[0] = stableCoin;
                                    tokenPath[1] = token;
                                    Router.swapTokensForExactTokens(
                                        _amount,
                                        amounts[1],
                                        tokenPath,
                                        msg.sender,
                                        block.timestamp + 300 // Transaction valid for 5 minutes.
                                    );
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        }
        revert("Not enough funds");
    }

    // Allows to pay the utility bill for one of the providers ONLY by an ALLOWED or OWNER/CREATOR of this Household contract.
    // Additionally will check if the payee can pay the required amount.
    // Function marked nonReentrant to guard against reentrancy
    function verifyBillPayment(address _member, uint256 _balance)
        external
        nonReentrant
        returns (bool)
    {
        require(
            _checkMember(ALLOWED, _member),
            "You're not an authorised member to pay the bill"
        );
        // Here the best crypto is selected as per the requirement
        _selectCrypto(_member, _balance);
        return true;
    }
}
