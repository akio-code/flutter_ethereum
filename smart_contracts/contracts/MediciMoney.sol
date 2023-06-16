// contracts/AkioCoin.sol
// SPDX-License-Identifier: MIT
// sepolia contract: 0x92e32dBE50CAE1fB5E81eFC8B4809A8beDD6DaFF
pragma solidity ^0.8.20;

import "solmate/src/tokens/ERC20.sol";

/**
 * @title Creator
 * @dev Contract to use as creator of new token
 * @author Lucas Akio
 */
contract Creator {
    address private creator;

    constructor() {
        creator = msg.sender;
    }

    /**
     * @dev Modifier to restrict function access to the creator only
     */
    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can call this function");
        _;
    }

    /**
     * @dev Function to get the address of the creator
     * @return The address of the creator
     */
    function getOwner() public view returns (address) {
        return creator;
    }
}

/**
 * @title MediciMoney (from renaissance)
 * @dev ERC20 token contract representing MediciMoney
 * @author Lucas Akio
 */
contract MediciMoney is ERC20, Creator {
    constructor() ERC20("MediciMoney", "MDC", 18) {}

    /**
     * @dev Mint new tokens, accessible only by the creator
     * @param amount The amount to mint
     * @return A boolean indicating if the transaction was successful
     */
    function mint(uint amount) public onlyCreator returns (bool) {
        _mint(msg.sender, amount*10**18);
        return true;
    }
}