// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Prasad is Ownable, ERC20 {
    constructor() Ownable(msg.sender) ERC20("PRASAD", "PW") {}

    function mint(address receiver, uint amount) public onlyOwner {
        _mint(receiver, amount);
    }
}
