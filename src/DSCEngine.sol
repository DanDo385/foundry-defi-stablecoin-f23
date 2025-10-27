// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title DSCEngine
 * @author Dan Magro
 * @notice This contract is the main contract for the DSCEngine system.
 * It is responsible for minting and burning DSC tokens, and for managing the
 * collateral and debt of the system.
 * @notice A-B-O Aways be Overcollateralized!
 * @notice This contrat is VERY loosely based on the MakerDAO DAI engine.
 */

contract DSCEngine {
    
    // Errors

    error DSCEngine__AmountMustBeGreaterThanZero();

    // State Variables

    mapping(address token => address priceFeed) private s_priceFeeds;
    
    // Modifiers

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__AmountMustBeGreaterThanZero();
        }
        _;
    }
    
    constructor() {}
    
    function depositCollateralAndMintDSC() external {}

    function depositCollateral() external {}

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    function mintDSC() external {}

    function burnDSC() external {}
    
    function liquidate() external {}
    
    function getHealthFactor() external view returns (uint256) {}
}



