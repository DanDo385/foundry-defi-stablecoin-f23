// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDSC} from "script/DeployDSC.s.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Handler} from "./Handler.t.sol";

/**
 * @title Invariants
 * @author Dan Magro
 * @notice Invariant tests with continueOnRevert policy
 * @dev Tests properties that must always hold, even if some calls revert
 */
contract Invariants is StdInvariant, Test {
    DSCEngine public dscEngine;
    DecentralizedStableCoin public dsc;
    HelperConfig public helperConfig;
    Handler public handler;

    address public weth;
    address public wbtc;

    function setUp() public {
        DeployDSC deployer = new DeployDSC();
        (dsc, dscEngine, helperConfig) = deployer.run();
        (,, weth, wbtc,) = helperConfig.activeNetworkConfig();
        handler = new Handler(dscEngine, dsc);
        targetContract(address(handler));
    }

    ///////////////////
    // Invariants
    ///////////////////

    /**
     * @notice Protocol must always be more collateralized than DSC minted
     * @dev Total collateral value >= Total DSC supply
     */
    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        uint256 totalSupply = dsc.totalSupply();
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dscEngine));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dscEngine));

        uint256 wethValue = dscEngine.getUsdValue(weth, totalWethDeposited);
        uint256 wbtcValue = dscEngine.getUsdValue(wbtc, totalWbtcDeposited);

        assert(wethValue + wbtcValue >= totalSupply);
    }

    /**
     * @notice All getter functions must never revert
     * @dev View functions should always be safe to call
     */
    function invariant_gettersShouldNotRevert() public view {
        dscEngine.getLiquidationBonus();
        dscEngine.getLiquidationThreshold();
        dscEngine.getMinHealthFactor();
        dscEngine.getPrecision();
        dscEngine.getDsc();
        dscEngine.getCollateralTokens();
    }

    /**
     * @notice Collateral tokens must be recognized
     * @dev Only WETH and WBTC should be allowed
     */
    function invariant_collateralTokensMustBeCorrect() public view {
        address[] memory tokens = dscEngine.getCollateralTokens();
        assert(tokens.length == 2);
        assert(tokens[0] == weth || tokens[0] == wbtc);
        assert(tokens[1] == weth || tokens[1] == wbtc);
    }
}
