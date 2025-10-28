// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";

/**
 * @title DecentralizedStableCoinTest
 * @author Dan Magro
 * @notice Unit tests for the DecentralizedStableCoin ERC20 token
 */
contract DecentralizedStableCoinTest is Test {
    DecentralizedStableCoin public dsc;
    address public owner;
    address public user = makeAddr("user");

    function setUp() public {
        dsc = new DecentralizedStableCoin();
        owner = address(this);
    }

    ////////////////////////
    // Constructor Tests  //
    ////////////////////////

    function testConstructorSetsCorrectNameAndSymbol() public view {
        assertEq(dsc.name(), "DecentralizedStableCoin");
        assertEq(dsc.symbol(), "DSC");
        assertEq(dsc.decimals(), 18);
    }

    function testOwnerIsSetCorrectly() public view {
        assertEq(dsc.owner(), owner);
    }

    ////////////////////////
    // Mint Tests         //
    ////////////////////////

    function testMintRevertsIfNotOwner() public {
        vm.prank(user);
        vm.expectRevert();
        dsc.mint(user, 100 ether);
    }

    function testMintRevertsIfAmountIsZero() public {
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__AmountMustBeGreaterThanZero.selector);
        dsc.mint(user, 0);
    }

    function testMintRevertsIfToIsZeroAddress() public {
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__NotZeroAddress.selector);
        dsc.mint(address(0), 100 ether);
    }

    function testMintSucceeds() public {
        uint256 amount = 100 ether;
        bool success = dsc.mint(user, amount);
        assertTrue(success);
        assertEq(dsc.balanceOf(user), amount);
        assertEq(dsc.totalSupply(), amount);
    }

    function testMintIncreasesTotalSupply() public {
        uint256 initialSupply = dsc.totalSupply();
        uint256 mintAmount = 50 ether;
        dsc.mint(user, mintAmount);
        assertEq(dsc.totalSupply(), initialSupply + mintAmount);
    }

    ////////////////////////
    // Burn Tests         //
    ////////////////////////

    function testBurnRevertsIfNotOwner() public {
        dsc.mint(owner, 100 ether);
        vm.prank(user);
        vm.expectRevert();
        dsc.burn(50 ether);
    }

    function testBurnRevertsIfAmountIsZero() public {
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__AmountMustBeGreaterThanZero.selector);
        dsc.burn(0);
    }

    function testBurnRevertsIfAmountExceedsBalance() public {
        dsc.mint(owner, 100 ether);
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__BurnAmountExceedsBalance.selector);
        dsc.burn(101 ether);
    }

    function testBurnSucceeds() public {
        uint256 mintAmount = 100 ether;
        uint256 burnAmount = 50 ether;

        dsc.mint(owner, mintAmount);
        dsc.burn(burnAmount);

        assertEq(dsc.balanceOf(owner), mintAmount - burnAmount);
        assertEq(dsc.totalSupply(), mintAmount - burnAmount);
    }

    function testBurnDecreasesTotalSupply() public {
        uint256 mintAmount = 100 ether;
        uint256 burnAmount = 50 ether;

        dsc.mint(owner, mintAmount);
        uint256 supplyBeforeBurn = dsc.totalSupply();
        dsc.burn(burnAmount);

        assertEq(dsc.totalSupply(), supplyBeforeBurn - burnAmount);
    }

    ////////////////////////
    // Transfer Tests     //
    ////////////////////////

    function testTransferWorks() public {
        uint256 amount = 100 ether;
        dsc.mint(owner, amount);

        bool success = dsc.transfer(user, amount);
        assertTrue(success);
        assertEq(dsc.balanceOf(owner), 0);
        assertEq(dsc.balanceOf(user), amount);
    }

    function testTransferFromWorks() public {
        uint256 amount = 100 ether;
        dsc.mint(owner, amount);

        vm.prank(owner);
        dsc.approve(user, amount);

        vm.prank(user);
        bool success = dsc.transferFrom(owner, user, amount);
        assertTrue(success);
        assertEq(dsc.balanceOf(owner), 0);
        assertEq(dsc.balanceOf(user), amount);
    }

    ////////////////////////
    // Allowance Tests    //
    ////////////////////////

    function testApproveWorks() public {
        uint256 amount = 100 ether;
        bool success = dsc.approve(user, amount);
        assertTrue(success);
        assertEq(dsc.allowance(owner, user), amount);
    }
}
