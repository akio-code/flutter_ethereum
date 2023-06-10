// SPDX-License-Identifier: UNLICENSED
// contract: 0x546cEA79ab2236CDADaFB61201E3f3332Ff35d08
pragma solidity ^0.8.0;

contract Foo {
    string public name;
    uint256 public bonusFactor;

    constructor(string memory _seller, uint256 _factor){
        name = _seller;
        bonusFactor = _factor;
    }

    function transfer(uint256 _amount) public view returns(uint256) {
        uint256 bonus = _amount * bonusFactor;
        return bonus;
    }
}
