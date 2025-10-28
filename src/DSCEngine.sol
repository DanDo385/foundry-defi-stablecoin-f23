// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AggregatorV3Interface} from "src/interfaces/AggregatorV3Interface.sol";
import {OracleLib} from "src/libraries/OracleLib.sol";

/**
 * @title DSCEngine
 * @author Dan Magro
 * @notice This contract is the core of the Decentralized Stablecoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 * @dev This contract is based on the MakerDAO DSS system
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token == $1 peg.
 * This stablecoin has the properties:
 * - Exogenous Collateral (ETH & BTC)
 * - Dollar Pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was only backed by WETH and WBTC.
 *
 * Our DSC system should always be "overcollateralized". At no point, should the value of all collateral <= the $ backed value of all the DSC.
 *
 * @notice This contract is VERY loosely based on the MakerDAO DSS (DAI) system.
 */
contract DSCEngine is ReentrancyGuard {
    using OracleLib for AggregatorV3Interface;

    ///////////////////
    // Errors
    ///////////////////
    error DSCEngine__AmountMustBeGreaterThanZero();
    error DSCEngine__TokenNotAllowed(address token);
    error DSCEngine__TransferFailed();
    error DSCEngine__BreaksHealthFactor(uint256 healthFactor);
    error DSCEngine__MintFailed();
    error DSCEngine__HealthFactorOk();
    error DSCEngine__HealthFactorNotImproved();

    ///////////////////
    // Events
    ///////////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);
    event CollateralRedeemed(
        address indexed redeemedFrom, address indexed redeemedTo, address indexed token, uint256 amount
    );
    event DscMinted(address indexed user, uint256 indexed amount);
    event DscBurned(address indexed user, uint256 indexed amount);
    event UserLiquidated(
        address indexed liquidator,
        address indexed user,
        address indexed collateralToken,
        uint256 debtCovered,
        uint256 collateralRedeemed
    );

    ///////////////////
    // State Variables
    ///////////////////

    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uint256 private constant PRECISION = 1e18;
    uint256 private constant LIQUIDATION_THRESHOLD = 50; // 50%
    uint256 private constant LIQUIDATION_BONUS = 10; // 10%
    uint256 private constant MIN_HEALTH_FACTOR = 1e18;

    mapping(address user => mapping(address collateralToken => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountDscMinted) private s_dscMinted;
    address[] private s_collateralTokens;
    mapping(address token => address priceFeed) private s_priceFeeds;

    DecentralizedStableCoin private immutable i_dsc;

    // Modifiers

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__AmountMustBeGreaterThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__TokenNotAllowed(token);
        }
        _;
    }

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert("Token addresses and price feed addresses must be same length");
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    ///////////////////
    // External Functions
    ///////////////////

    /**
     * @notice Deposits collateral and mints DSC in one transaction
     * @param tokenCollateralAddress The ERC20 token address to deposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     * @param amountDscToMint The amount of DSC to mint
     * @dev This function combines `depositCollateral` and `mintDsc` for gas efficiency
     */
    function depositCollateralAndMintDSC(
        address tokenCollateralAddress,
        uint256 amountCollateral,
        uint256 amountDscToMint
    ) external {
        depositCollateral(tokenCollateralAddress, amountCollateral);
        mintDsc(amountDscToMint);
    }

    /**
     * @notice Deposits collateral into the system
     * @param tokenCollateralAddress The ERC20 token address to deposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        public
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    /**
     * @notice Burns DSC and redeems underlying collateral in one transaction
     * @param tokenCollateralAddress The ERC20 token address to redeem
     * @param amountCollateral The amount of collateral to redeem
     * @param amountDscToBurn The amount of DSC to burn
     * @dev This function combines `burnDsc` and `redeemCollateral` for gas efficiency
     */
    function redeemCollateralForDSC(address tokenCollateralAddress, uint256 amountCollateral, uint256 amountDscToBurn)
        external
    {
        burnDsc(amountDscToBurn);
        redeemCollateral(tokenCollateralAddress, amountCollateral);
    }

    /**
     * @notice Redeems collateral from the system
     * @param tokenCollateralAddress The ERC20 token address to redeem
     * @param amountCollateral The amount of collateral to redeem
     * @dev This function will revert if the health factor is broken after redeeming
     */
    function redeemCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        public
        moreThanZero(amountCollateral)
        nonReentrant
    {
        _redeemCollateral(msg.sender, msg.sender, tokenCollateralAddress, amountCollateral);
        _revertIfHealthFactorIsBroken(msg.sender);
    }

    /**
     * @notice Mints DSC to the caller
     * @param amountDscToMint The amount of DSC to mint
     * @dev The caller must have enough collateral deposited
     */
    function mintDsc(uint256 amountDscToMint) public moreThanZero(amountDscToMint) nonReentrant {
        s_dscMinted[msg.sender] += amountDscToMint;
        _revertIfHealthFactorIsBroken(msg.sender);
        emit DscMinted(msg.sender, amountDscToMint);
        bool minted = i_dsc.mint(msg.sender, amountDscToMint);
        if (!minted) {
            revert DSCEngine__MintFailed();
        }
    }

    /**
     * @notice Burns DSC from the caller's balance
     * @param amount The amount of DSC to burn
     * @dev The caller must approve this contract to spend their DSC
     */
    function burnDsc(uint256 amount) public moreThanZero(amount) {
        s_dscMinted[msg.sender] -= amount;
        emit DscBurned(msg.sender, amount);
        bool success = i_dsc.transferFrom(msg.sender, address(this), amount);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
        i_dsc.burn(amount);
    }

    /**
     * @notice Liquidates a user's position if their health factor is below the minimum
     * @param collateral The ERC20 collateral token address to liquidate from the user
     * @param user The user who has broken the health factor. Their health factor should be below MIN_HEALTH_FACTOR
     * @param debtToCover The amount of DSC to burn to improve the user's health factor
     * @dev You can partially liquidate a user
     * @dev You will get a liquidation bonus for taking the user's funds
     * @dev This function working assumes the protocol will be roughly 200% overcollateralized in order for this to work
     * @dev A known bug would be if the protocol were 100% or less collateralized, then we wouldn't be able to incentivize liquidators
     */
    function liquidate(address collateral, address user, uint256 debtToCover)
        external
        moreThanZero(debtToCover)
        nonReentrant
    {
        uint256 startingUserHealthFactor = _healthFactor(user);
        if (startingUserHealthFactor >= MIN_HEALTH_FACTOR) {
            revert DSCEngine__HealthFactorOk();
        }

        uint256 tokenAmountFromDebtCovered = getTokenAmountFromUsd(collateral, debtToCover);
        uint256 bonusCollateral = (tokenAmountFromDebtCovered * LIQUIDATION_BONUS) / 100;
        uint256 totalCollateralToRedeem = tokenAmountFromDebtCovered + bonusCollateral;

        _redeemCollateral(user, msg.sender, collateral, totalCollateralToRedeem);
        _burnDsc(debtToCover, user, msg.sender);

        emit UserLiquidated(msg.sender, user, collateral, debtToCover, totalCollateralToRedeem);

        uint256 endingUserHealthFactor = _healthFactor(user);
        if (endingUserHealthFactor <= startingUserHealthFactor) {
            revert DSCEngine__HealthFactorNotImproved();
        }
        _revertIfHealthFactorIsBroken(msg.sender);
    }

    ///////////////////
    // Public & External View Functions
    ///////////////////

    /**
     * @notice Returns the health factor of a user
     * @param user The address of the user
     * @return The health factor of the user
     */
    function getHealthFactor(address user) external view returns (uint256) {
        return _healthFactor(user);
    }

    function getTokenAmountFromUsd(address token, uint256 usdAmountInWei) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[token]);
        uint256 price = priceFeed.getSafePrice();
        return (usdAmountInWei * PRECISION) / (price * ADDITIONAL_FEED_PRECISION);
    }

    function getAccountInformation(address user)
        public
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_dscMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    function getAccountCollateralValue(address user) public view returns (uint256 totalCollateralValueInUsd) {
        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_collateralDeposited[user][token];
            totalCollateralValueInUsd += getUsdValue(token, amount);
        }
        return totalCollateralValueInUsd;
    }

    function getUsdValue(address token, uint256 amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[token]);
        uint256 price = priceFeed.getSafePrice();
        return ((price * ADDITIONAL_FEED_PRECISION) * amount) / PRECISION;
    }

    ///////////////////
    // Private & Internal Functions
    ///////////////////

    function _redeemCollateral(address from, address to, address tokenCollateralAddress, uint256 amountCollateral)
        private
    {
        s_collateralDeposited[from][tokenCollateralAddress] -= amountCollateral;
        emit CollateralRedeemed(from, to, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transfer(to, amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function _burnDsc(uint256 amountDscToBurn, address onBehalfOf, address dscFrom) private {
        s_dscMinted[onBehalfOf] -= amountDscToBurn;
        bool success = i_dsc.transferFrom(dscFrom, address(this), amountDscToBurn);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
        i_dsc.burn(amountDscToBurn);
    }

    function _revertIfHealthFactorIsBroken(address user) internal view {
        uint256 userHealthFactor = _healthFactor(user);
        if (userHealthFactor < MIN_HEALTH_FACTOR) {
            revert DSCEngine__BreaksHealthFactor(userHealthFactor);
        }
    }

    function _healthFactor(address user) private view returns (uint256) {
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = getAccountInformation(user);
        if (totalDscMinted == 0) return type(uint256).max;

        uint256 collateralAdjustedForThreshold = (collateralValueInUsd * LIQUIDATION_THRESHOLD) / 100;
        return (collateralAdjustedForThreshold * PRECISION) / totalDscMinted;
    }

    // Getter Functions
    function getLiquidationThreshold() external pure returns (uint256) {
        return LIQUIDATION_THRESHOLD;
    }

    function getLiquidationBonus() external pure returns (uint256) {
        return LIQUIDATION_BONUS;
    }

    function getPrecision() external pure returns (uint256) {
        return PRECISION;
    }

    function getCollateralTokens() external view returns (address[] memory) {
        return s_collateralTokens;
    }

    function getCollateralTokenPriceFeed(address token) external view returns (address) {
        return s_priceFeeds[token];
    }

    function getDsc() external view returns (address) {
        return address(i_dsc);
    }

    function getMinHealthFactor() external pure returns (uint256) {
        return MIN_HEALTH_FACTOR;
    }

    function getCollateralBalanceOfUser(address user, address token) external view returns (uint256) {
        return s_collateralDeposited[user][token];
    }
}
