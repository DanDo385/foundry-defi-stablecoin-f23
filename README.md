# Decentralized Stablecoin (DSC) - DeFi Protocol

A fully decentralized, algorithmically stable, exogenously collateralized stablecoin pegged to $1 USD. Built with Foundry and inspired by MakerDAO's DAI, but without governance, fees, and only backed by WETH and WBTC.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Building and Compiling](#building-and-compiling)
- [Testing](#testing)
  - [Unit Tests](#unit-tests)
  - [Fuzz Tests](#fuzz-tests)
  - [Invariant Tests](#invariant-tests)
  - [Integration Tests](#integration-tests)
- [Deployment](#deployment)
  - [Local Deployment (Anvil)](#local-deployment-anvil)
  - [Testnet Deployment](#testnet-deployment)
  - [Mainnet Deployment](#mainnet-deployment)
- [Interacting with Contracts](#interacting-with-contracts)
  - [Using Cast CLI](#using-cast-cli)
  - [Using Scripts](#using-scripts)
- [Configuration](#configuration)
- [Gas Optimization](#gas-optimization)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## 🎯 Overview

The DSC (Decentralized Stablecoin) system is a minimal, over-collateralized stablecoin protocol that maintains a 1:1 peg with the US Dollar. The system is designed to always be **over-collateralized** (at least 200%) to ensure the stability and security of the protocol.

### Key Properties

- **Exogenous Collateral**: Backed by WETH (Wrapped Ether) and WBTC (Wrapped Bitcoin)
- **Dollar Pegged**: 1 DSC = $1 USD
- **Algorithmically Stable**: No governance, automated liquidations
- **Over-collateralized**: Protocol requires >200% collateralization ratio

### Smart Contracts

1. **DecentralizedStableCoin.sol**: ERC20 token implementation of DSC
2. **DSCEngine.sol**: Core protocol logic for minting, burning, deposits, withdrawals, and liquidations
3. **OracleLib.sol**: Chainlink price feed wrapper with staleness checks

---

## ✨ Features

- ✅ Deposit collateral (WETH/WBTC) and mint DSC
- ✅ Burn DSC and redeem collateral
- ✅ Automated liquidations when health factor < 1
- ✅ Chainlink price feeds for accurate collateral valuation
- ✅ Oracle staleness protection (3-hour timeout)
- ✅ Liquidation bonuses (10%) to incentivize liquidators
- ✅ Health factor monitoring
- ✅ Comprehensive test suite (unit, fuzz, invariant, integration)

---

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

```bash
# Foundry (forge, cast, anvil, chisel)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Verify installation
forge --version
cast --version
anvil --version

# Git (to clone dependencies)
git --version

# A wallet with some test ETH (for testnets)
# MetaMask or any Web3 wallet recommended
```

---

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/foundry-defi-stablecoin-f23.git
cd foundry-defi-stablecoin-f23
```

### 2. Install Dependencies

Foundry uses git submodules for dependencies:

```bash
# Install all dependencies
forge install

# Or install individually:
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install smartcontractkit/chainlink-brownie-contracts --no-commit
```

### 3. Environment Setup

Create a `.env` file in the root directory:

```bash
# .env file
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE

# Optional: For mainnet deployments
MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_ALCHEMY_KEY
```

⚠️ **Important**: Never commit your `.env` file! Add it to `.gitignore`.

### 4. Load Environment Variables

```bash
source .env
```

---

## 📁 Project Structure

```
foundry-defi-stablecoin-f23/
├── src/
│   ├── DecentralizedStableCoin.sol     # ERC20 stablecoin token
│   ├── DSCEngine.sol                   # Core protocol logic
│   ├── AggregatorV3Interface.sol       # Chainlink interface
│   └── libraries/
│       └── OracleLib.sol               # Oracle helper library
├── script/
│   ├── DeployDSC.s.sol                 # Deployment script
│   ├── HelperConfig.s.sol              # Network configurations
│   └── Interactions.s.sol              # Interaction examples
├── test/
│   ├── unit/                           # Unit tests
│   │   ├── DSCEngineTest.t.sol
│   │   ├── DecentralizedStableCoinTest.t.sol
│   │   └── mocks/
│   ├── fuzz/                           # Fuzz/property tests
│   │   └── DSCEngineFuzzTest.t.sol
│   ├── integration/                    # Integration tests
│   │   └── DSCProtocolIntegrationTest.t.sol
│   ├── continueOnRevert/               # Invariant tests (no revert)
│   │   ├── Handler.t.sol
│   │   └── Invariants.t.sol
│   └── failOnRevert/                   # Invariant tests (strict)
│       ├── Handler.t.sol
│       └── Invariants.t.sol
├── lib/                                # Dependencies (git submodules)
├── out/                                # Compiled artifacts
├── cache/                              # Compilation cache
├── foundry.toml                        # Foundry configuration
└── README.md
```

---

## 🔨 Building and Compiling

### Compile Contracts

```bash
# Standard compilation
forge build

# Compile with detailed output
forge build --sizes

# Compile with optimizer runs specified
forge build --optimizer-runs 200

# Compile with extra optimization
forge build --via-ir

# Clean build (removes cache and artifacts)
forge clean && forge build
```

### Check Contract Sizes

```bash
# See contract sizes (helps with contract size limit)
forge build --sizes
```

### Format Code

```bash
# Format all Solidity files
forge fmt

# Check formatting without making changes
forge fmt --check
```

---

## 🧪 Testing

This project includes comprehensive testing at multiple levels:

### Run All Tests

```bash
# Run all tests
forge test

# Run with verbosity (shows console logs)
forge test -vv

# Run with extreme verbosity (shows stack traces)
forge test -vvvv

# Run with gas reporting
forge test --gas-report
```

### Unit Tests

Unit tests focus on individual functions and contract behavior.

```bash
# Run only unit tests
forge test --match-path "test/unit/**/*.sol"

# Run specific test file
forge test --match-path "test/unit/DSCEngineTest.t.sol"

# Run specific test function
forge test --match-test testDepositCollateral

# Run tests matching a pattern
forge test --match-test "testDeposit*"
```

**Key Unit Tests:**
- `DSCEngineTest.t.sol`: Tests all DSCEngine functions
- `DecentralizedStableCoinTest.t.sol`: Tests DSC token functionality

### Fuzz Tests

Fuzz tests use random inputs to find edge cases.

```bash
# Run fuzz tests
forge test --match-path "test/fuzz/**/*.sol"

# Run with more iterations (default is 256)
forge test --match-path "test/fuzz/**/*.sol" --fuzz-runs 10000

# Run specific fuzz test
forge test --match-path "test/fuzz/DSCEngineFuzzTest.t.sol" -vv
```

**Fuzz Test Examples:**
- Random deposit amounts
- Random mint amounts
- Random collateral types
- Boundary conditions

### Invariant Tests

Invariant tests ensure critical properties always hold true.

```bash
# Run continueOnRevert invariants (doesn't fail on reverts)
forge test --match-path "test/continueOnRevert/**/*.sol"

# Run failOnRevert invariants (strict mode)
forge test --match-path "test/failOnRevert/**/*.sol"

# Run with specific depth and runs
forge test --match-path "test/continueOnRevert/**/*.sol" \
  --invariant-runs 256 \
  --invariant-depth 128
```

**Key Invariants Tested:**
1. Protocol must always be over-collateralized
2. Users can't mint more DSC than their collateral allows
3. Liquidations always improve health factor
4. Total DSC supply ≤ Total collateral value / 2

### Integration Tests

Integration tests verify end-to-end workflows.

```bash
# Run integration tests
forge test --match-path "test/integration/**/*.sol" -vv

# Run with fork testing (requires RPC URL)
forge test --match-path "test/integration/**/*.sol" \
  --fork-url $SEPOLIA_RPC_URL
```

**Integration Test Scenarios:**
- Full user journey: deposit → mint → burn → redeem
- Multi-user interactions
- Liquidation scenarios
- Oracle price updates

### Coverage

```bash
# Generate coverage report
forge coverage

# Generate detailed coverage report
forge coverage --report lcov

# Generate HTML coverage report (requires lcov)
forge coverage --report lcov && genhtml lcov.info -o coverage
```

### Gas Snapshots

```bash
# Create gas snapshot
forge snapshot

# Compare gas usage
forge snapshot --diff .gas-snapshot

# Generate gas report for specific test
forge test --match-path "test/unit/DSCEngineTest.t.sol" --gas-report
```

---

## 🚀 Deployment

### Local Deployment (Anvil)

Anvil is a local Ethereum node for testing.

#### Step 1: Start Anvil

```bash
# Start Anvil with default settings
anvil

# Start with specific block time
anvil --block-time 12

# Start with specific chain ID
anvil --chain-id 31337

# Start with more accounts
anvil --accounts 20
```

Anvil will display test accounts and private keys. Save these for testing.

#### Step 2: Deploy Contracts

In a new terminal:

```bash
# Deploy to Anvil
forge script script/DeployDSC.s.sol:DeployDSC \
  --rpc-url http://localhost:8545 \
  --broadcast \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# The script will output deployed addresses
# Save these addresses for interactions
```

**Expected Output:**
```
DSC Engine deployed at: 0x...
DSC Token deployed at: 0x...
WETH Token at: 0x...
WBTC Token at: 0x...
```

### Testnet Deployment

#### Step 1: Ensure Your Wallet Has Testnet ETH

Get Sepolia ETH from:
- [Alchemy Sepolia Faucet](https://sepoliafaucet.com/)
- [Infura Sepolia Faucet](https://www.infura.io/faucet/sepolia)

#### Step 2: Deploy to Sepolia

```bash
# Deploy to Sepolia testnet
forge script script/DeployDSC.s.sol:DeployDSC \
  --rpc-url $SEPOLIA_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --private-key $PRIVATE_KEY

# Or using keystore (more secure)
forge script script/DeployDSC.s.sol:DeployDSC \
  --rpc-url $SEPOLIA_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --account myKeystore
```

#### Step 3: Verify Contracts Manually (if auto-verify fails)

```bash
# Verify DSCEngine
forge verify-contract \
  --chain-id 11155111 \
  --compiler-version v0.8.18+commit.87f61d96 \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  <CONTRACT_ADDRESS> \
  src/DSCEngine.sol:DSCEngine

# Verify DecentralizedStableCoin
forge verify-contract \
  --chain-id 11155111 \
  --compiler-version v0.8.18+commit.87f61d96 \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  <CONTRACT_ADDRESS> \
  src/DecentralizedStableCoin.sol:DecentralizedStableCoin
```

### Mainnet Deployment

⚠️ **WARNING**: Mainnet deployment involves real money. Ensure thorough testing before deploying!

```bash
# Deploy to Ethereum Mainnet
forge script script/DeployDSC.s.sol:DeployDSC \
  --rpc-url $MAINNET_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --private-key $PRIVATE_KEY \
  --slow \
  --legacy

# Use --slow to avoid rate limiting
# Use --legacy for chains that don't support EIP-1559
```

**Pre-deployment Checklist:**
- ✅ All tests passing
- ✅ Security audit completed
- ✅ Gas optimization verified
- ✅ Emergency pause mechanism tested
- ✅ Oracle feeds verified
- ✅ Multi-sig wallet setup for ownership

---

## 💻 Interacting with Contracts

### Using Cast CLI

Cast is Foundry's command-line tool for interacting with contracts.

#### Read Contract Data

```bash
# Get DSC balance of an address
cast call <DSC_ADDRESS> \
  "balanceOf(address)(uint256)" \
  <USER_ADDRESS> \
  --rpc-url $SEPOLIA_RPC_URL

# Get collateral deposited by user
cast call <ENGINE_ADDRESS> \
  "getCollateralBalanceOfUser(address,address)(uint256)" \
  <USER_ADDRESS> \
  <WETH_ADDRESS> \
  --rpc-url $SEPOLIA_RPC_URL

# Get user's health factor
cast call <ENGINE_ADDRESS> \
  "getHealthFactor(address)(uint256)" \
  <USER_ADDRESS> \
  --rpc-url $SEPOLIA_RPC_URL

# Get account information
cast call <ENGINE_ADDRESS> \
  "getAccountInformation(address)(uint256,uint256)" \
  <USER_ADDRESS> \
  --rpc-url $SEPOLIA_RPC_URL

# Get USD value of collateral
cast call <ENGINE_ADDRESS> \
  "getUsdValue(address,uint256)(uint256)" \
  <WETH_ADDRESS> \
  1000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL
```

#### Write Transactions

```bash
# Approve WETH spending
cast send <WETH_ADDRESS> \
  "approve(address,uint256)" \
  <ENGINE_ADDRESS> \
  10000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY

# Deposit collateral
cast send <ENGINE_ADDRESS> \
  "depositCollateral(address,uint256)" \
  <WETH_ADDRESS> \
  5000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY

# Mint DSC
cast send <ENGINE_ADDRESS> \
  "mintDsc(uint256)" \
  100000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY

# Burn DSC
cast send <ENGINE_ADDRESS> \
  "burnDsc(uint256)" \
  50000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY

# Redeem collateral
cast send <ENGINE_ADDRESS> \
  "redeemCollateral(address,uint256)" \
  <WETH_ADDRESS> \
  1000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY

# Liquidate a user
cast send <ENGINE_ADDRESS> \
  "liquidate(address,address,uint256)" \
  <WETH_ADDRESS> \
  <USER_TO_LIQUIDATE> \
  50000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY
```

#### Monitor Events

```bash
# Watch for CollateralDeposited events
cast logs \
  --from-block latest \
  --address <ENGINE_ADDRESS> \
  'CollateralDeposited(address,address,uint256)' \
  --rpc-url $SEPOLIA_RPC_URL

# Get past events
cast logs \
  --from-block 12345 \
  --to-block latest \
  --address <ENGINE_ADDRESS> \
  'DscMinted(address,uint256)' \
  --rpc-url $SEPOLIA_RPC_URL
```

### Using Scripts

#### Run Interaction Script

```bash
# Run the interaction script (deposits & mints)
forge script script/Interactions.s.sol:Interactions \
  --rpc-url $SEPOLIA_RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY
```

#### Create Custom Interaction Scripts

Create a new script in `script/` directory:

```solidity
// script/MyInteraction.s.sol
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DSCEngine} from "src/DSCEngine.sol";

contract MyInteraction is Script {
    function run() external {
        address engineAddress = 0x...; // Your deployed engine
        DSCEngine engine = DSCEngine(engineAddress);

        vm.startBroadcast();
        // Your interaction logic here
        vm.stopBroadcast();
    }
}
```

Run it:

```bash
forge script script/MyInteraction.s.sol:MyInteraction \
  --rpc-url $SEPOLIA_RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY
```

---

## ⚙️ Configuration

### Foundry Configuration (`foundry.toml`)

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
remappings = [
    "@chainlink/=lib/chainlink-brownie-contracts/",
    "@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/"
]

# Fuzz testing configuration
[fuzz]
runs = 256                    # Number of fuzz runs
max_test_rejects = 65536      # Max rejected inputs
seed = '0x1'                  # Seed for reproducibility

# Invariant testing configuration
[invariant]
runs = 256                    # Number of invariant runs
depth = 128                   # Call depth per run
fail_on_revert = false        # Continue on reverts
call_override = false         # Don't override calls

# Strict profile for failOnRevert tests
[profile.strict]
fuzz = { runs = 256 }
invariant = { runs = 128, depth = 64, fail_on_revert = true }
```

### Network Configurations

Networks are configured in `script/HelperConfig.s.sol`:

- **Local (Anvil)**: Deploys mocks for testing
- **Sepolia**: Uses Chainlink price feeds
- **Mainnet**: Production configuration

---

## ⛽ Gas Optimization

### Check Gas Usage

```bash
# Generate gas report
forge test --gas-report

# Save gas snapshot
forge snapshot

# Compare gas changes
forge snapshot --diff .gas-snapshot

# Run specific test with gas report
forge test --match-test testDepositCollateral --gas-report
```

### Optimization Tips

1. **Use `calldata` instead of `memory`** for external function parameters
2. **Pack storage variables** to use fewer slots
3. **Use `uint256`** instead of smaller integers (less gas on EVM)
4. **Avoid unnecessary storage reads** - cache to memory
5. **Use events for data** instead of storage when possible

---

## 🔒 Security

### Security Best Practices

1. **Reentrancy Protection**: All external calls use `nonReentrant` modifier
2. **Oracle Staleness Checks**: OracleLib validates price feed freshness
3. **Health Factor Checks**: Prevents under-collateralization
4. **Access Control**: Only DSCEngine can mint/burn DSC
5. **Input Validation**: All inputs validated (non-zero, allowed tokens)

### Run Static Analysis

```bash
# Install Slither
pip3 install slither-analyzer

# Run Slither
slither .

# Run specific detectors
slither . --detect reentrancy-eth,unused-return

# Exclude specific paths
slither . --exclude-dependencies
```

### Security Audit Checklist

- [ ] Reentrancy vulnerabilities
- [ ] Integer overflow/underflow
- [ ] Access control issues
- [ ] Oracle manipulation
- [ ] Flash loan attacks
- [ ] Price manipulation
- [ ] Liquidation front-running
- [ ] DoS attacks

---

## 🐛 Troubleshooting

### Common Issues

#### 1. **"Failed to resolve imports"**

```bash
# Solution: Install dependencies
forge install

# Or update
forge update
```

#### 2. **"Compiler version mismatch"**

```bash
# Solution: Use correct Solidity version
forge build --use 0.8.18
```

#### 3. **"RPC connection failed"**

```bash
# Check RPC URL is correct
echo $SEPOLIA_RPC_URL

# Test connection
cast block-number --rpc-url $SEPOLIA_RPC_URL
```

#### 4. **"Insufficient funds for gas"**

```bash
# Check balance
cast balance <YOUR_ADDRESS> --rpc-url $SEPOLIA_RPC_URL

# Get testnet ETH from faucet
```

#### 5. **"Nonce too low"**

```bash
# Reset your account nonce
cast nonce <YOUR_ADDRESS> --rpc-url $SEPOLIA_RPC_URL
```

#### 6. **Tests failing on CI/CD**

```bash
# Ensure RPC_URL is available
# Try with --no-rate-limit flag
forge test --no-rate-limit
```

### Debug Mode

```bash
# Run test in debug mode
forge test --match-test testFailingTest --debug

# This opens an interactive debugger
# Use 'n' to step, 'c' to continue, 'q' to quit
```

### Verbose Logging

```bash
# Level 1: Show test results
forge test -v

# Level 2: Show logs and assertion errors
forge test -vv

# Level 3: Show stack traces for failing tests
forge test -vvv

# Level 4: Show stack traces for all tests + setup
forge test -vvvv

# Level 5: Show all execution traces
forge test -vvvvv
```

---

## 📚 Additional Resources

### Foundry Documentation
- [Foundry Book](https://book.getfoundry.sh/)
- [Forge Commands](https://book.getfoundry.sh/reference/forge/)
- [Cast Commands](https://book.getfoundry.sh/reference/cast/)
- [Cheatcodes Reference](https://book.getfoundry.sh/cheatcodes/)

### Smart Contract Security
- [Consensys Best Practices](https://consensys.github.io/smart-contract-best-practices/)
- [SWC Registry](https://swcregistry.io/)
- [DeFi Security](https://github.com/OffcierCia/DeFi-Developer-Road-Map)

### Chainlink Documentation
- [Price Feeds](https://docs.chain.link/data-feeds)
- [Feed Registry](https://docs.chain.link/data-feeds/feed-registry)

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📞 Support

If you have questions or need help:

- Open an issue on GitHub
- Check existing issues and discussions
- Review the Foundry Book documentation

---

## ⚠️ Disclaimer

This code is for educational purposes. It has not been audited and should not be used in production without proper security review and testing. Use at your own risk.

---

**Built with ❤️ using Foundry**
