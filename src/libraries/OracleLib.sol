// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "src/interfaces/AggregatorV3Interface.sol";

/**
 * @title OracleLib
 * @author Dan Magro
 * @notice This library is used to check the Chainlink Oracle for stale data.
 * If a price is stale, the function will revert, and render the DSCEngine unusable - this is by design.
 * We want the DSCEngine to freeze if prices become stale.
 *
 * So if the Chainlink network explodes and you have a lot of money locked in the protocol... too bad.
 */
library OracleLib {
    error OracleLib__StalePrice();
    error OracleLib__PriceLessThanOrEqualToZero();

    uint256 private constant TIMEOUT = 3 hours;

    /**
     * @notice Checks the Chainlink price feed for stale data
     * @param priceFeed The Chainlink price feed to check
     * @return The price from the price feed
     * @dev This function will revert if the price is stale or less than or equal to zero
     */
    function getSafePrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();
        if (updatedAt == 0 || block.timestamp - updatedAt > TIMEOUT) {
            revert OracleLib__StalePrice();
        }
        if (price <= 0) {
            revert OracleLib__PriceLessThanOrEqualToZero();
        }
        return uint256(price);
    }
}
