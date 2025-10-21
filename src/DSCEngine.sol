// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title DSCEngine
 * @author Dan Magro
 * @notice This contract is the main contract for the DSCEngine system.
 * It is responsible for minting and burning DSC tokens, and for managing the
 * collateral and debt of the system.
 * @notice This contrat is VERY loosely based on the MakerDAO DAI engine.
 */

contract DSCEngine {
    function depositCollateralAndMintDSC() external {}

    function redeemCollateralForDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}
    
    function getHealthFactor() external view returns (uint256) {}
    
}
