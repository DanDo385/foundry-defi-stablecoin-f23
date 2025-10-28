// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract DSCEngineFuzzTest is Test {
    DSCEngine private dsce;
    DecentralizedStableCoin private dsc;
    HelperConfig private helperConfig;

    address private weth;
    address private wbtc;

    address private constant USER = address(0xBEEF);

    function setUp() public {
        dsc = new DecentralizedStableCoin();
        helperConfig = new HelperConfig();
        (address ethUsdPriceFeed, address btcUsdPriceFeed, address wethToken, address wbtcToken,) =
            helperConfig.activeNetworkConfig();

        address[] memory collateralTokens = new address[](2);
        collateralTokens[0] = wethToken;
        collateralTokens[1] = wbtcToken;

        address[] memory priceFeeds = new address[](2);
        priceFeeds[0] = ethUsdPriceFeed;
        priceFeeds[1] = btcUsdPriceFeed;

        dsce = new DSCEngine(collateralTokens, priceFeeds, address(dsc));
        dsc.transferOwnership(address(dsce));

        weth = wethToken;
        wbtc = wbtcToken;
    }

    function testFuzz_DepositCollateralUpdatesBalance(uint256 collateralAmount) public {
        collateralAmount = bound(collateralAmount, 1e15, 1000 ether);
        deal(weth, USER, collateralAmount);

        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), collateralAmount);
        dsce.depositCollateral(weth, collateralAmount);
        vm.stopPrank();

        assertEq(dsce.getCollateralBalanceOfUser(USER, weth), collateralAmount);
        assertEq(ERC20Mock(weth).balanceOf(USER), 0);
    }

    function testFuzz_MintWithinHealthFactor(uint256 collateralAmount, uint256 mintAmount) public {
        collateralAmount = bound(collateralAmount, 1 ether, 500 ether);
        deal(weth, USER, collateralAmount);

        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), collateralAmount);
        dsce.depositCollateral(weth, collateralAmount);

        uint256 collateralValue = dsce.getUsdValue(weth, collateralAmount);
        uint256 maxMint = (collateralValue * dsce.getLiquidationThreshold()) / 100;
        vm.assume(maxMint > 1);

        mintAmount = bound(mintAmount, 1, maxMint - 1);
        dsce.mintDsc(mintAmount);
        vm.stopPrank();

        uint256 healthFactor = dsce.getHealthFactor(USER);
        assertGe(healthFactor, dsce.getMinHealthFactor());
        assertEq(dsc.balanceOf(USER), mintAmount);
    }

    function testFuzz_BurnAndRedeemRestoresState(
        uint256 collateralAmount,
        uint256 mintAmount,
        uint256 burnAmount
    ) public {
        collateralAmount = bound(collateralAmount, 5 ether, 500 ether);
        deal(weth, USER, collateralAmount);

        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), collateralAmount);
        dsce.depositCollateral(weth, collateralAmount);

        uint256 collateralValue = dsce.getUsdValue(weth, collateralAmount);
        uint256 maxMint = (collateralValue * dsce.getLiquidationThreshold()) / 100;
        uint256 safeMaxMint = maxMint / 2;
        vm.assume(safeMaxMint > 2);

        mintAmount = bound(mintAmount, 2, safeMaxMint);
        dsce.mintDsc(mintAmount);

        burnAmount = bound(burnAmount, 1, mintAmount - 1);
        dsc.approve(address(dsce), burnAmount);
        dsce.burnDsc(burnAmount);

        dsce.redeemCollateral(weth, collateralAmount / 2);
        vm.stopPrank();

        (uint256 totalMinted, uint256 collateralValueAfter) = dsce.getAccountInformation(USER);
        assertEq(totalMinted, mintAmount - burnAmount);
        uint256 expectedCollateralValue = dsce.getUsdValue(weth, collateralAmount / 2);
        assertApproxEqAbs(collateralValueAfter, expectedCollateralValue, dsce.getPrecision());
        assertEq(dsc.balanceOf(USER), mintAmount - burnAmount);
    }
}
