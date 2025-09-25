// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DecentralizedStableCoin {
    constructor() ERC20("DecentralizedStableCoin", "DSC") {