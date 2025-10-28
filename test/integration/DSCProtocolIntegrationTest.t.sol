// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {MockV3Aggregator} from "test/unit/mocks/MockV3Aggregator.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract DSCProtocolIntegrationTest is Test {
    DSCEngine private dsce;
    DecentralizedStableCoin private dsc;
    HelperConfig private helperConfig;

    address private ethUsdPriceFeed;
    address private weth;
    address private wbtc;

    address private alice = makeAddr("alice");
    address private bob = makeAddr("bob");
    address private liquidator = makeAddr("liquidator");

    function setUp() public {
        dsc = new DecentralizedStableCoin();
        helperConfig = new HelperConfig();
        (address ethFeed, address btcFeed, address wethToken, address wbtcToken,) = helperConfig.activeNetworkConfig();
        ethUsdPriceFeed = ethFeed;
        weth = wethToken;
        wbtc = wbtcToken;

        address[] memory collateralTokens = new address[](2);
        collateralTokens[0] = wethToken;
        collateralTokens[1] = wbtcToken;

        address[] memory priceFeeds = new address[](2);
        priceFeeds[0] = ethFeed;
        priceFeeds[1] = btcFeed;

        dsce = new DSCEngine(collateralTokens, priceFeeds, address(dsc));
        dsc.transferOwnership(address(dsce));
    }

    function testIntegration_LiquidationFlow() public {
        uint256 aliceDeposit = 100 ether;
        _fundAndApprove(alice, weth, aliceDeposit);

        vm.startPrank(alice);
        dsce.depositCollateral(weth, aliceDeposit);
        uint256 collateralValue = dsce.getUsdValue(weth, aliceDeposit);
        uint256 maxMint = (collateralValue * dsce.getLiquidationThreshold()) / 100;
        uint256 mintAmount = maxMint / 2;
        dsce.mintDsc(mintAmount);
        vm.stopPrank();

        MockV3Aggregator(ethUsdPriceFeed).updateAnswer(900e8);
        uint256 healthFactorBefore = dsce.getHealthFactor(alice);
        assertLt(healthFactorBefore, dsce.getMinHealthFactor());

        vm.startPrank(address(dsce));
        dsc.mint(liquidator, mintAmount / 2);
        vm.stopPrank();

        vm.startPrank(liquidator);
        dsc.approve(address(dsce), mintAmount / 2);
        dsce.liquidate(weth, alice, mintAmount / 2);
        vm.stopPrank();

        uint256 healthFactorAfter = dsce.getHealthFactor(alice);
        assertGe(healthFactorAfter, dsce.getMinHealthFactor());
        assertGt(ERC20Mock(weth).balanceOf(liquidator), 0);
    }

    function testIntegration_RedeemAcrossCollaterals() public {
        uint256 wethDeposit = 50 ether;
        uint256 wbtcDeposit = 10 ether;

        _fundAndApprove(bob, weth, wethDeposit);
        _fundAndApprove(bob, wbtc, wbtcDeposit);

        vm.startPrank(bob);
        dsce.depositCollateral(weth, wethDeposit);
        dsce.depositCollateral(wbtc, wbtcDeposit);

        uint256 totalCollateralValue = dsce.getAccountCollateralValue(bob);
        uint256 mintAmount = (totalCollateralValue * 30) / 100;
        dsce.mintDsc(mintAmount);

        dsc.approve(address(dsce), mintAmount);
        dsce.burnDsc(mintAmount);
        dsce.redeemCollateral(weth, wethDeposit);
        dsce.redeemCollateral(wbtc, wbtcDeposit);
        vm.stopPrank();

        (uint256 totalMinted, uint256 collateralValueAfter) = dsce.getAccountInformation(bob);
        assertEq(totalMinted, 0);
        assertEq(collateralValueAfter, 0);
        assertEq(ERC20Mock(weth).balanceOf(bob), wethDeposit);
        assertEq(ERC20Mock(wbtc).balanceOf(bob), wbtcDeposit);
    }

    function _fundAndApprove(address user, address token, uint256 amount) private {
        deal(token, user, amount);
        vm.prank(user);
        ERC20Mock(token).approve(address(dsce), amount);
    }
}
