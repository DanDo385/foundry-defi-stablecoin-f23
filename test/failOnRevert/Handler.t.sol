// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {MockV3Aggregator} from "test/unit/mocks/MockV3Aggregator.sol";

/**
 * @title Handler
 * @author Dan Magro
 * @notice Handler for failOnRevert invariant tests
 * @dev Wraps DSCEngine calls with stricter validation - NO try/catch
 * Fails immediately if any call reverts
 */
contract Handler is Test {
    DSCEngine public dscEngine;
    DecentralizedStableCoin public dsc;

    ERC20Mock public weth;
    ERC20Mock public wbtc;

    // Ghost variables
    uint256 public timesMintCalled;
    uint256 public timesDepositCalled;
    uint256 public timesRedeemCalled;
    uint256 public timesBurnCalled;

    address[] public usersWithCollateralDeposited;
    mapping(address => bool) public hasDeposited;

    uint256 constant MAX_DEPOSIT = type(uint96).max;

    constructor(DSCEngine _dscEngine, DecentralizedStableCoin _dsc) {
        dscEngine = _dscEngine;
        dsc = _dsc;

        address[] memory collateralTokens = dscEngine.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);
    }

    ///////////////////
    // Handler Functions
    ///////////////////

    /**
     * @notice Deposit collateral - will revert if invalid
     * @dev No try/catch - stricter validation
     */
    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dscEngine), amountCollateral);
        dscEngine.depositCollateral(address(collateral), amountCollateral);
        vm.stopPrank();

        timesDepositCalled++;
        if (!hasDeposited[msg.sender]) {
            usersWithCollateralDeposited.push(msg.sender);
            hasDeposited[msg.sender] = true;
        }
    }

    /**
     * @notice Mint DSC - more conservative bounds
     * @dev Only mints up to 25% of collateral value
     */
    function mintDsc(uint256 amount, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) return;

        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = dscEngine.getAccountInformation(sender);

        // More conservative - only mint up to 25% of collateral value
        int256 maxDscToMint = int256(collateralValueInUsd / 4) - int256(totalDscMinted);
        if (maxDscToMint <= 0) return;

        amount = bound(amount, 1, uint256(maxDscToMint));

        vm.prank(sender);
        dscEngine.mintDsc(amount);
        timesMintCalled++;
    }

    /**
     * @notice Redeem collateral - will revert if invalid
     * @dev No try/catch - must succeed
     */
    function redeemCollateral(uint256 collateralSeed, uint256 amountCollateral, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) return;

        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];

        uint256 maxCollateral = dscEngine.getCollateralBalanceOfUser(sender, address(collateral));
        if (maxCollateral == 0) return;

        // More conservative with redeem
        amountCollateral = bound(amountCollateral, 0, maxCollateral / 2);
        if (amountCollateral == 0) return;

        vm.prank(sender);
        dscEngine.redeemCollateral(address(collateral), amountCollateral);
        timesRedeemCalled++;
    }

    /**
     * @notice Burn DSC - will revert if invalid
     * @dev No try/catch - must succeed
     */
    function burnDsc(uint256 amount, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) return;

        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];
        (uint256 dscMinted,) = dscEngine.getAccountInformation(sender);

        if (dscMinted == 0) return;

        // Only burn a portion to maintain health
        amount = bound(amount, 1, dscMinted / 2);

        vm.startPrank(sender);
        dsc.approve(address(dscEngine), amount);
        dscEngine.burnDsc(amount);
        vm.stopPrank();

        timesBurnCalled++;
    }

    ///////////////////
    // Helper Functions
    ///////////////////

    function _getCollateralFromSeed(uint256 collateralSeed) private view returns (ERC20Mock) {
        if (collateralSeed % 2 == 0) {
            return weth;
        }
        return wbtc;
    }
}
