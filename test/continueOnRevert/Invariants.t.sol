// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
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

        uint256 precision = dscEngine.getPrecision();
        assert(wethValue + wbtcValue + precision >= totalSupply);
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

    /**
     * @notice Handler's debt bookkeeping should mirror DSCEngine state per user
     */
    function invariant_trackedDebtAlignsWithEngineState() public view {
        address[] memory users = handler.getUsersWithCollateralDeposited();
        for (uint256 i = 0; i < users.length; i++) {
            (uint256 minted,) = dscEngine.getAccountInformation(users[i]);
            assertEq(handler.trackedMintedForUser(users[i]), minted);
        }
    }

    /**
     * @notice Sum of user collateral balances should equal engine token holdings
     */
    function invariant_collateralBalancesMatchAccounting() public view {
        address[] memory users = handler.getUsersWithCollateralDeposited();
        uint256 totalWethDeposits;
        uint256 totalWbtcDeposits;
        for (uint256 i = 0; i < users.length; i++) {
            totalWethDeposits += dscEngine.getCollateralBalanceOfUser(users[i], weth);
            totalWbtcDeposits += dscEngine.getCollateralBalanceOfUser(users[i], wbtc);
        }
        assertEq(IERC20(weth).balanceOf(address(dscEngine)), totalWethDeposits);
        assertEq(IERC20(wbtc).balanceOf(address(dscEngine)), totalWbtcDeposits);
    }

    /**
     * @notice Every user tracked by the handler should stay above the minimum health factor
     * @dev Users with no debt return max uint and are ignored
     */
    function invariant_userHealthFactorStaysAboveMinimum() public view {
        address[] memory users = handler.getUsersWithCollateralDeposited();
        uint256 minHealthFactor = dscEngine.getMinHealthFactor();
        for (uint256 i = 0; i < users.length; i++) {
            uint256 healthFactor = dscEngine.getHealthFactor(users[i]);
            if (healthFactor == type(uint256).max) {
                continue;
            }
            assert(healthFactor >= minHealthFactor);
        }
    }
}
