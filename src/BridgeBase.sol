// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IBPrasad is IERC20 {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract BridgeBase is Ownable {

    address public tokenAddress ;

    mapping(address => uint) userBalances;

    event Burn(address indexed from,uint amount);

    constructor(address _tokenAddress) Ownable(msg.sender){
        tokenAddress = _tokenAddress;
    }

    function mint(IBPrasad _tokenAddress , uint _amount) public {
        require(address(_tokenAddress) == tokenAddress);
        require(userBalances[msg.sender] >= _amount);
        // userBalances[msg.sender] += _amount;
        _tokenAddress.mint(msg.sender, _amount);
    }

    function burn(IBPrasad _tokenAddress , uint _amount) public {
        require(address(_tokenAddress) == tokenAddress);
        require(userBalances[msg.sender] >= _amount);
        userBalances[msg.sender] -= _amount;
        _tokenAddress.burn(msg.sender, _amount);
        emit Burn(msg.sender,_amount);

    }

    function depositedOnTheOtherBlockchain(address userAccount, uint256 _amount) public onlyOwner {
        userBalances[userAccount] += _amount;
    }

}