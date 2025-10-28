// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "src/interfaces/AggregatorV3Interface.sol";

/**
 * @title MockV3Aggregator
 * @notice This is a mock Chainlink price feed for testing purposes
 */
contract MockV3Aggregator is AggregatorV3Interface {
    uint8 public s_decimals;
    int256 public s_answer;

    constructor(uint8 _decimals, int256 _initialAnswer) {
        s_decimals = _decimals;
        s_answer = _initialAnswer;
    }

    function decimals() external view override returns (uint8) {
        return s_decimals;
    }

    function description() external pure override returns (string memory) {
        return "Mock V3 Aggregator";
    }

    function version() external pure override returns (uint256) {
        return 1;
    }

    function getRoundData(uint80 /*_roundId*/ )
        external
        view
        override
        returns (uint80, int256, uint256, uint256, uint80)
    {
        return (1, s_answer, block.timestamp, block.timestamp, 1);
    }

    function latestRoundData() external view override returns (uint80, int256, uint256, uint256, uint80) {
        return (1, s_answer, block.timestamp, block.timestamp, 1);
    }

    function updateAnswer(int256 _newAnswer) public {
        s_answer = _newAnswer;
    }
}
