// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "../interfaces/AggregatorV3Interface.sol";

library OracleLib {
    error OracleLib__StalePrice();
    error OracleLib__PriceLessThanOrEqualToZero();

    uint256 private constant TIMEOUT = 3 hours;

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
