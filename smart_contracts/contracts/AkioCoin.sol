// contracts/AkioCoin.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AkioCoin is ERC20 {
  constructor() ERC20("AkioCoin", "AKC") {
    _mint(msg.sender, 199*10**18);
  }
}