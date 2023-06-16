// contracts/AkioCoin.sol
// SPDX-License-Identifier: MIT
// sepolia contract: 0x92e32dBE50CAE1fB5E81eFC8B4809A8beDD6DaFF
pragma solidity ^0.8.20;

import "solmate/src/tokens/ERC20.sol";

contract Creator {
    address private creator;

    constructor() {
        creator = msg.sender;
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can call this function");
        _;
    }

    function getOwner() public view returns (address) {
        return creator;
    }
}

contract MediciMoney is ERC20, Creator {
    constructor() ERC20("MediciMoney", "MDC", 18) {}

    function mint(uint amount) public onlyCreator returns (bool) {
        _mint(msg.sender, amount*10**18);
        return true;
    }
}