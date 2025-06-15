// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeEth is Ownable {
    address public tokenAddress;

    event Deposit(address indexed depositer, uint amount);

    mapping(address => uint) userBalances;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function lock(IERC20 _tokenAddress , uint _amount) public {
        require(address(_tokenAddress) == tokenAddress);
        require(_tokenAddress.allowance(msg.sender, address(this)) >= _amount);
        require(_tokenAddress.transferFrom(msg.sender, address(this), _amount));
        emit Deposit(msg.sender, _amount);
    }

    function unlock(IERC20 _tokenAddress , uint _amount) public {
        require(address(_tokenAddress) == tokenAddress);
        require(userBalances[msg.sender] >= _amount);
        userBalances[msg.sender] -= _amount;
        _tokenAddress.transfer(msg.sender, _amount);
    }

    function burnedOnOtherBlockchain(address userAccount, uint256 _amount) public onlyOwner {
        userBalances[userAccount] += _amount; 
    }
}
