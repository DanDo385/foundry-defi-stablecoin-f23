// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {MockV3Aggregator} from "test/unit/mocks/MockV3Aggregator.sol";

/**
 * @title Handler
 * @author Dan Magro
 * @notice Handler for continueOnRevert invariant tests
 * @dev Wraps DSCEngine calls with bounded inputs and tracks ghost variables
 * Uses try/catch to continue on revert
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
    uint256 public trackedTotalMinted;

    address[] public usersWithCollateralDeposited;
    mapping(address => bool) public hasDeposited;
    mapping(address => uint256) public trackedMintedForUser;

    uint256 constant MAX_DEPOSIT = 100 ether;

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

    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dscEngine), amountCollateral);

        try dscEngine.depositCollateral(address(collateral), amountCollateral) {
            timesDepositCalled++;
            if (!hasDeposited[msg.sender]) {
                usersWithCollateralDeposited.push(msg.sender);
                hasDeposited[msg.sender] = true;
            }
        } catch {}
        vm.stopPrank();
    }

    function mintDsc(uint256 amount, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) return;

        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = dscEngine.getAccountInformation(sender);

        int256 maxDscToMint = int256(collateralValueInUsd / 3) - int256(totalDscMinted);
        if (maxDscToMint <= 0) return;

        amount = bound(amount, 1, uint256(maxDscToMint));

        vm.startPrank(sender);
        try dscEngine.mintDsc(amount) {
            timesMintCalled++;
            trackedTotalMinted += amount;
            trackedMintedForUser[sender] += amount;
        } catch {}
        vm.stopPrank();
    }

    function redeemCollateral(uint256 collateralSeed, uint256 amountCollateral, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) return;

        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];

        uint256 maxCollateral = dscEngine.getCollateralBalanceOfUser(sender, address(collateral));
        if (maxCollateral == 0) return;

        amountCollateral = bound(amountCollateral, 0, maxCollateral);
        if (amountCollateral == 0) return;

        vm.startPrank(sender);
        try dscEngine.redeemCollateral(address(collateral), amountCollateral) {
            timesRedeemCalled++;
        } catch {}
        vm.stopPrank();
    }

    function burnDsc(uint256 amount, uint256 addressSeed) public {
        if (usersWithCollateralDeposited.length == 0) return;

        address sender = usersWithCollateralDeposited[addressSeed % usersWithCollateralDeposited.length];
        (uint256 dscMinted,) = dscEngine.getAccountInformation(sender);

        if (dscMinted == 0) return;

        amount = bound(amount, 1, dscMinted);

        vm.startPrank(sender);
        dsc.approve(address(dscEngine), amount);
        try dscEngine.burnDsc(amount) {
            timesBurnCalled++;
            trackedTotalMinted -= amount;
            trackedMintedForUser[sender] -= amount;
        } catch {}
        vm.stopPrank();
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

    function getUsersWithCollateralDeposited() external view returns (address[] memory) {
        return usersWithCollateralDeposited;
    }
}
