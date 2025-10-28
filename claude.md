Advanced Foundry Section 3: Foundry DeFi | Stablecoin (The PINNACLE PROJECT!! GET HERE!)
💻 Code: https://github.com/Cyfrin/foundry-defi-stablecoin-cu

This is one of the top projects you can build in the blockchain space. A decentralized stablecoin! We will teach you about the differences between DAI, USDC, RAI, and other stablecoins, and allow you to build your own.

Introduction
⭐️ Section 3: DeFi Stablecoins

What is DeFi?
What is DeFi?
DefiLlama
Bankless
MEV
Aave
My Previous Aave Video on Shorting Assets
DAI
Uniswap
Maximal Extractable Value (MEV)
Code Walkthrough
⌨️ Code Walkthrough

What is a smart contract audit
What is a stablecoin (But actually)
⌨️ What is a stablecoin (But actually)

Video
MakerDAO Forums
DecentralizedStableCoin.sol
⌨️ DecentralizedStableCoin.sol

What is a smart contract audit
super
DSCEngine.sol Setup
⌨️ DSCEngine.sol Setup

liquidations
nonreentrant
reentrancy
Deposit Collateral
⌨️ Deposit Collateral

Other DeFi Examples:
Aave V2 Docs
Aave NPM
Mint DSC
Getting the value of our collateral
⌨️ Getting the value of our collateral

Aave Borrowing FAQs
Health Factor
Aave Risk Parameters
Health Factor
⌨️ Health Factor

Liquidation Threshold
Minting the DSC
⌨️ Minting the DSC

Testing while developing
Deploy Script
⌨️ Deploy Script

WETH Token Sepolia Etherscan
WETH Token Mainnet
Tests
⌨️ Tests

depositCollateralAndMintDsc
⌨️ depositCollateralAndMintDsc

redeemCollateral
⌨️ redeemCollateral

Liquidate
Setup
⌨️ Setup

Refactoring
⌨️ Refactoring

Leveling up your testing skillz
⌨️ Leveling up your testing skillz

Challenge: Get DSCEngine.sol test coverage above 85%
Fuzz (Invariant) Testing
⌨️ Fuzz (Invariant) Testing

Video
Open-based Fuzz tests
⌨️ Open-based Fuzz tests

Handler-based Fuzz tests
revert_on_fail = true
⌨️ revert_on_fail = true

Create the collateral redeemal handler
⌨️ Create the collateral redeemal handler

DeFi Handler Deposit Collateral
⌨️ DeFi Handler Deposit Collateral

Minting DSC
⌨️ Minting DSC

Debugging Fuzz Tests
⌨️ Debugging Fuzz Tests

Ghost Variables
Challenge: Find out why mintDsc is never being called on our Handler.sol
Price Feed Handling
⌨️ Price Feed Handling

OracleLib
⌨️ OracleLib

Note on audit preparedness
⌨️ Note on audit preparedness

Simple security checklist
Recap
⌨️ Recap

Lens Protocol
⌨️ Lens Protocol

Special Guest Nader
Lens Protocol
More DeFi Learnings:
Defi-Minimal
Defi Dad
Advanced Foundry Section 3 NFTs
ZKsync
Sepolia
(back to top) ⬆️

Advanced Foundry Section 4: Foundry Cross Chain Rebase Token
💻 Code: https://github.com/Cyfrin/foundry-cross-chain-rebase-token-cu

Introduction and Code Walkthrough
⌨️ Introduction and Code Walkthrough

What is a rebase token
⌨️ What is a rebase token

Rebase token code structure
⌨️ Rebase token code structure

Writing the rebase token contract
⌨️ Writing the rebase token contract

mintInterest and burn functions
⌨️ mintInterest and burn functions

Finish rebase token contract
⌨️ Finish rebase token contract

Access control
⌨️ Access control

Vault and NATSPEC
⌨️ Vault and NATSPEC

Rebase token tests part 1
⌨️ Rebase token tests part 1

Rebase token tests part 2
⌨️ Rebase token tests part 2

Vulnerabilities and cross-chain intro
⌨️ Vulnerabilities and cross-chain intro

Bridging
⌨️ Bridging

CCIP
⌨️ CCIP

The CCT standard
⌨️ The CCT standard

## Circle CCTP

⌨️ Circle CCTP

Pool contract
⌨️ Pool contract

Finish pool contract
⌨️ Finish pool contract

📦 Dependency Update Notice
🔄 Update: This project previously used the smartcontractkit/ccip repository.
🆕 You should now use the updated, more actively maintained smartcontractkit/chainlink repository instead.

🔁 Remappings
To ensure clean and maintainable import paths, use the following remappings in your foundry.toml or a separate remappings.txt file:

remappings = [
    '@openzeppelin/=lib/openzeppelin-contracts/',
    '@chainlink/=lib/chainlink/',
]
Chainlink local and fork testing
⌨️ Chainlink local and fork testing

Deploy token test
⌨️ Deploy token test

CCIP setup test
⌨️ CCIP setup test

Configure pool test
⌨️ Configure pool test

Bridge function test
⌨️ Bridge function test

First cross chain test
⌨️ First cross chain test

Vault deployer script
⌨️ Vault deployer script

Token and pool deployer script
⌨️ Token and pool deployer script

Pool config script
⌨️ Pool config script

Bridging script
⌨️ Bridging script

Build scripts
⌨️ Build scripts

Run scripts on testnet
⌨️ Run scripts on testnet

Cross chain message received
⌨️ Cross chain message received

Outro
⌨️ Outro

Advanced Foundry Section 5: Foundry Merkle Airdrop and Signatures
💻 Code: https://github.com/Cyfrin/foundry-merkle-airdrop-cu

Introduction to Merkle Airdrops and Code Walkthrough
⌨️ Introduction

Project Setup
⌨️ Project Setup

Merkle Proofs
⌨️ Merkle Proofs

Base Airdrop Contract
⌨️ Base Airdrop Contract

Second preimage attack articles [1, 2]
Already Claimed Check
⌨️ Already Claimed Check

Merkle Tree Scripts
⌨️ Merkle Tree Scripts

Writing the Tests
⌨️ Writing the Tests

Deployment Script
⌨️ Deployment Script

Adding Signature Verification
⌨️ Adding Signature Verification

Signature Standards
⌨️ Signature Standards

EIP-191
EIP-712
Signature standards article
ECDSA Signatures
⌨️ ECDSA Signatures

ECDSA signatures article
Signature Malleability - Section 4 of the Replay Attacks Article
Transaction Types Introduction
⌨️ Transaction Types Introduction

Transaction Types
⌨️ Transaction Types

Ethereum transaction types
ZKsync transaction types
Blob Transactions
⌨️ Blob Transactions

Blob transactions article
Type 113 Transactions
Implementing Signatures
Modifying the Tests
Test on ZKsync (optional)
Create Claiming Script
Creating a Signature
Splitting a Signature
Executing the Anvil Script
Deploy and Claim on ZKsync Local Node
Deploy and Claim on ZKsync Sepolia
Summary
Advanced Foundry Section 5 NFTs (TBD)
Advanced Foundry Section 6: Foundry Upgrades
💻 Code: https://github.com/Cyfrin/foundry-upgrades-cu

Introduction
⭐️ Section 5: Upgradable Contracts & Proxies

Upgradable Smart Contracts Overview
Optional Video
Types of Upgrades
Parameter
Social Migrate
Proxy
Proxy Gotchas
Function Collisions
Storage Collisions
Metamorphic Upgrades
Transparent
UUPS
Diamond
Delegatecall
⌨️ Delegatecall

delegatecall (solidity-by-example)
Yul
Small Proxy Example
⌨️ Small Proxy Example

EIP 1967
Universal Upgradable Smart Contract
Setup
⌨️ UUPS Setup

UUPS vs Transparent
Abstract Contracts
Deploy
⌨️ Deploy

ERC-1967
UpgradeBox
⌨️ Upgradebox

Test/Demo
⌨️ (5:53:48) | Test/Demo

Testnet Demo
⌨️ Testnet Demo

Advanced Foundry Section 6 NFTs
ZKsync
Sepolia
(back to top) ⬆️

Advanced Foundry Section 7: Foundry Account Abstraction
💻 Code: https://github.com/Cyfrin/minimal-account-abstraction

What is account abstraction?
⌨️ Account Abstraction Introduction

What is native account abstraction?
How does ZKsync do account abstraction?
What is EIP-4337?
What are ZKsync system contracts?
Code Overview
⌨️ Code Overview

Ethereum Setup
⌨️ Ethereum Account Abstraction

PackedUserOperation
⌨️ PackedUserOperation

Validate UserOp
⌨️ Validate UserOp

EntryPoint Contract
⌨️ EntryPoint Contract

Execute Function Ethereum
⌨️ Execute

Deployment Script for an Ethereum Account
⌨️ Deploy Script

Tests Owner can Execute
⌨️ Tests Owner can Execute

Unsigned PackedUserOperation Test
⌨️ Get Unsigned PackedUserOperation

Signed UserOp Test
⌨️ Signed PackedUserOperation

Using unlocked accounts for local development
⌨️ Local Dev Unlocked

Test Validation of User Ops
⌨️ Test Validate UserOps

Test Entry Point
⌨️ Test Entry Point

Advanced Debugging
⌨️ Advanced Debugging

Mid-session Recap
⌨️ Mid Session Recap

Live Demo on Arbitrum
⌨️ Live Demo

ZKsync Native Account Abstraction
⌨️ ZKsync Setup

IAccount
⌨️ IAccount

System Contracts
⌨️ System Contracts

Type 113 LifeCycle
⌨️ TxType 113 Lifecycle

Mid-ZKsync Recap
⌨️ ZKsync Accounts Recap

System Contract Call ZKsync Simulations
⌨️ ZKsync Transaction Simulations

Validate Transaction ZKsync
⌨️ ValidateTransaction

Execute Function ZKsync
⌨️ executeTransaction

Pay For Transaction ZKsync
⌨️ payForTransaction

Execute Transaction From Outside
⌨️ executeTransactionFromOutside

ZKsync Tests
⌨️ ZKsync Tests

Building a Transaction Struct
⌨️ Transaction Struct

Via Ir
⌨️ --via-ir

Validate Transaction Test
⌨️ Validate Transaction Test

Clean Up ZKsync
⌨️ Clean up

Testnet ZKsync Demo
⌨️ Testnet Demo

Recap & End
⌨️ Recap End

Advanced Foundry Section 7 NFTs (TBD)
Advanced Foundry Section 8: Foundry DAO / Governance
Plutocracy is bad! Don't default to ERC20 token voting!!

💻 Code: https://github.com/Cyfrin/foundry-dao-cu

Introduction
⭐️ Section 14 | DAOs & Governance

Plutocracy is bad
DAOs are not corporations
What is a DAO?
What is a DAO?
Special Guest Juliette
How to build a DAO
DAOs toolings - Introduction to Aragon
⌨️ DAOs tooling - Special Guest from Aragon

Project Setup
⌨️ Build your own DAO Setup

How to build a DAO
That's Patrick
PY Code
Python Video
Governance Token
⌨️ Governance Tokens

Openzeppelin Governance
Compound Governance
Contract Wizard
Governor
⌨️ Creating the Governor Contract

CastVoteBySig
Tests
⌨️ Testing the Governor Contract

Wrap up
⌨️ Section Recap

Bonus: Gas optimization tips
Special Guest Harrison
Advanced Foundry Section 8 NFTs
ZKsync
Sepolia
(back to top) ⬆️

Advanced Foundry Section 9: Smart Contract Security & Auditing (For developers)
Developers 100% should know all about this! Don't leave the course without at least watching this section!

Important

PLEASE AT LEAST WATCH THE DOCKER CONTAINER SECTION OF THIS CURRICULUM!! You can find a shorter video of the docker curriculum here. We highly recommend you head over to the end-to-end Cyfrin Updraft Security and Auditing Curriculum.

🖥️ Code: https://github.com/PatrickAlphaC/denver-security

Introduction
⭐️ Section 6 | Security & Auditing

Readiness Checklist
What is a smart contract audit?
⌨️ What is a smart contract audit?

What is a smart contract audit Cyfrin Channel Video
Tools
⌨️ What tools do security professionals use?

Manual Review
⌨️ Intro to Manual review

Static Analysis
Slither
4nlyzer
Dynamic Analysis
Formal Verification
Symbolic Execution
Manticore
Mythril
hevm
Comparison
Fuzzing
Echidna
Foundry
Consensys
Formal Verification (& Symbolic Execution)
Comparisons
Other security stuff
solcurity
What does the process of manual review look like?
⌨️ Manual Review with Tincho

Tincho finds $100,000 ENS bug
Formal Verification
⌨️ Formal Verification

Formal Verification & Symbolic Execution | W/ Trail Of Bits
Isolated Development Environments
Watch this video
Closing Thoughts
⌨️ Wrap. Up

Common Attacks
Best Practices
Attacks
Oracle Attacks
Damn Vulnerable Defi
Ethernaut
Top Smart Contract Auditors
Some Smart Contract Auditors:
Cyfrin
OpenZeppelin
SigmaPrime
Trail of Bits
Spearbit
Dedaub
Trust
More
Advanced Foundry Section 9 NFTs
ZKsync
Sepolia
(back to top) ⬆️

Congratulations
🎊🎊🎊🎊🎊🎊🎊🎊🎊🎊🎊🎊 Completed all The Course! 🎊🎊🎊🎊🎊🎊🎊🎊🎊🎊🎊🎊

Where do I go now?
Learning More
Top 10 learning resources
Patrick Collins
CryptoZombies
Alchemy University
Speed Run Ethereum
Ethereum.org
Community
Twitter
Ethereum Discord
Reddit ethdev
Hackathons
CL Hackathon
ETH Global
ETH India
Be sure to check out project grant programs!

And make today an amazing day!

