// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {DeployDSC} from "./DeployDSC.s.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Interactions is Script {
    uint256 private constant COLLATERAL_TO_DEPOSIT = 10 ether;

    function run() external {
        DeployDSC deployer = new DeployDSC();
        (DecentralizedStableCoin dsc, DSCEngine dsce, HelperConfig helperConfig) = deployer.run();
        (address wethFeed, address wbtcFeed, address wethToken, address wbtcToken, uint256 deployerKey) =
            helperConfig.activeNetworkConfig();
        HelperConfig.NetworkConfig memory config =
            HelperConfig.NetworkConfig({wethUsdPriceFeed: wethFeed, wbtcUsdPriceFeed: wbtcFeed, weth: wethToken, wbtc: wbtcToken, deployerKey: deployerKey});

        uint256 collateralValue = dsce.getUsdValue(config.weth, COLLATERAL_TO_DEPOSIT);
        uint256 safeMintAmount = (collateralValue * dsce.getLiquidationThreshold()) / 100 / 2;

        vm.startBroadcast(config.deployerKey);
        if (block.chainid == 31337) {
            ERC20Mock(config.weth).mint(msg.sender, COLLATERAL_TO_DEPOSIT);
        }
        ERC20Mock(config.weth).approve(address(dsce), COLLATERAL_TO_DEPOSIT);
        dsce.depositCollateralAndMintDSC(config.weth, COLLATERAL_TO_DEPOSIT, safeMintAmount);
        vm.stopBroadcast();

        console2.log("DSC Engine deployed at", address(dsce));
        console2.log("DSC token deployed at", address(dsc));
        console2.log("Deposited WETH amount", COLLATERAL_TO_DEPOSIT);
        console2.log("Minted DSC amount", safeMintAmount);
    }
}
