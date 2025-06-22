// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {Prasad} from "../src/Prasad.sol";
import {BPrasad} from "../src/BPrasad.sol";
import {BridgeEth} from "../src/BridgeEth.sol";
import {BridgeBase} from "../src/BridgeBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBPrasad is IERC20 {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract BridgeTest is Test {
    Prasad prasadCoin;
    IBPrasad BPrasadCoin;
    BridgeEth bridgeEth;
    BridgeBase bridgeBase;
    event Deposit(address indexed depositer, uint amount);
     event Burn(address indexed from,uint amount);

    function setUp() public {
        prasadCoin = new Prasad();
        BPrasadCoin = IBPrasad(address(new BPrasad()));
        bridgeEth = new BridgeEth(address(prasadCoin));
        bridgeBase = new BridgeBase(address(BPrasadCoin));
    }

    function testBridgeAndUnBridge() public {
        prasadCoin.mint(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a, 100);

        vm.startPrank(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a);

        prasadCoin.approve(address(bridgeEth), 50);
        vm.expectEmit(true, false, false, true);
        emit Deposit(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a, 50);
        bridgeEth.lock(prasadCoin, 50);

        assertEq(
            prasadCoin.balanceOf(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a),
            50
        );
        assertEq(prasadCoin.balanceOf(address(bridgeEth)), 50);

        vm.stopPrank();
        bridgeBase.depositedOnTheOtherBlockchain(
            0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a,
            50
        );

        vm.startPrank(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a);
        BPrasad(address(BPrasadCoin)).mint(
            0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a,
            50
        );

        assertEq(
            BPrasadCoin.balanceOf(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a),
            50
        );

        BPrasad(address(BPrasadCoin)).burn(
            0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a,
            30
        );

        vm.stopPrank();

        bridgeEth.burnedOnOtherBlockchain(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a, 30);

        vm.startPrank(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a);

        bridgeEth.unlock(prasadCoin, 30);

        assertEq(prasadCoin.balanceOf(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a),80);
        assertEq(BPrasadCoin.balanceOf(0x6b33AfEcce4198E5127d4c8970c16C1ed75Cc62a),20);

    }
}
