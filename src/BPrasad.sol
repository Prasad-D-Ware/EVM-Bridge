// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BPrasad is Ownable, ERC20 {
    constructor() Ownable(msg.sender) ERC20("BridgedPRASAD", "BPW") {}

    function mint(address receiver, uint amount) public {
        _mint(receiver, amount);
    }

    function burn(address receiver, uint amount) public {
        _burn(receiver, amount);
    }
}
