Foundry DeFi Stablecoin
This is a section of the Cyfrin Foundry Solidity Course.

DSCEngine Example Decentralized Stablecoin Example

About
This project is meant to be a stablecoin where users can deposit WETH and WBTC in exchange for a token that will be pegged to the USD.

Foundry DeFi Stablecoin
About
Getting Started
Requirements
Quickstart
Optional Gitpod
Updates
Usage
Start a local node
Deploy
Deploy - Other Network
Testing
Test Coverage
Deployment to a testnet or mainnet
Scripts
Estimate gas
Formatting
Slither
Additional Info:
Let's talk about what "Official" means
Summary
Thank you!
Getting Started
Requirements
git
You'll know you did it right if you can run git --version and you see a response like git version x.x.x
foundry
You'll know you did it right if you can run forge --version and you see a response like forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)
Quickstart
git clone https://github.com/Cyfrin/foundry-defi-stablecoin-cu
cd foundry-defi-stablecoin-cu
forge build
Optional Gitpod
If you can't or don't want to run and install locally, you can work with this repo in Gitpod. If you do this, you can skip the clone this repo part.

Open in Gitpod

Updates
The latest version of openzeppelin-contracts has changes in the ERC20Mock file. To follow along with the course, you need to install version 4.8.3 which can be done by forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit instead of forge install openzeppelin/openzeppelin-contracts --no-commit
Usage
Start a local node
make anvil
Deploy
This will default to your local node. You need to have it running in another terminal in order for it to deploy.

make deploy
Deploy - Other Network
See below

Testing
We talk about 4 test tiers in the video.

Unit
Integration
Forked
Staging
In this repo we cover #1 and Fuzzing.

forge test
Test Coverage
forge coverage
and for coverage based testing:

forge coverage --report debug
Deployment to a testnet or mainnet
Setup environment variables
You'll want to set your SEPOLIA_RPC_URL and PRIVATE_KEY as environment variables. You can add them to a .env file, similar to what you see in .env.example.

PRIVATE_KEY: The private key of your account (like from metamask). NOTE: FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
You can learn how to export it here.
SEPOLIA_RPC_URL: This is url of the sepolia testnet node you're working with. You can get setup with one for free from Alchemy
Optionally, add your ETHERSCAN_API_KEY if you want to verify your contract on Etherscan.

Get testnet ETH
Head over to faucets.chain.link and get some testnet ETH. You should see the ETH show up in your metamask.

Deploy
make deploy ARGS="--network sepolia"
Scripts
Instead of scripts, we can directly use the cast command to interact with the contract.

For example, on Sepolia:

Get some WETH
cast send 0xdd13E55209Fd76AfE204dBda4007C227904f0a81 "deposit()" --value 0.1ether --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
Approve the WETH
cast send 0xdd13E55209Fd76AfE204dBda4007C227904f0a81 "approve(address,uint256)" 0x091EA0838eBD5b7ddA2F2A641B068d6D59639b98 1000000000000000000 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
Deposit and Mint DSC
cast send 0x091EA0838eBD5b7ddA2F2A641B068d6D59639b98 "depositCollateralAndMintDsc(address,uint256,uint256)" 0xdd13E55209Fd76AfE204dBda4007C227904f0a81 100000000000000000 10000000000000000 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
Estimate gas
You can estimate how much gas things cost by running:

forge snapshot
And you'll see an output file called .gas-snapshot

Formatting
To run code formatting:

forge fmt
Slither
slither :; slither . --config-file slither.config.json
Additional Info:
Some users were having a confusion that whether Chainlink-brownie-contracts is an official Chainlink repository or not. Here is the info. Chainlink-brownie-contracts is an official repo. The repository is owned and maintained by the chainlink team for this very purpose, and gets releases from the proper chainlink release process. You can see it's still the smartcontractkit org as well.

https://github.com/smartcontractkit/chainlink-brownie-contracts

Let's talk about what "Official" means
The "official" release process is that chainlink deploys it's packages to npm. So technically, even downloading directly from smartcontractkit/chainlink is wrong, because it could be using unreleased code.

So, then you have two options:

Download from NPM and have your codebase have dependencies foreign to foundry
Download from the chainlink-brownie-contracts repo which already downloads from npm and then packages it nicely for you to use in foundry.
Summary
That is an official repo maintained by the same org
It downloads from the official release cycle chainlink/contracts use (npm) and packages it nicely for digestion from foundry.

Project Layout

.
├── README.md
├── foundry.lock
├── foundry.toml
├── lib
│   └── forge-std
│       ├── CONTRIBUTING.md
│       ├── LICENSE-APACHE
│       ├── LICENSE-MIT
│       ├── README.md
│       ├── RELEASE_CHECKLIST.md
│       ├── foundry.toml
│       ├── package.json
│       ├── scripts
│       ├── src
│       └── test
├── script
│   └── Counter.s.sol
├── src
│   └── Counter.sol
└── test
    └── Counter.t.sol

9 directories, 13 files

You can configure Foundry's behavior using foundry.toml. Configuration can be extended from base files using the extends field (see Configuration Inheritance below for details).
Remappings are specified in remappings.txt.
The default directory for contracts is src/.
The default directory for tests is test/, where any contract with a function that starts with test is considered to be a test.
Dependencies are stored as git submodules in lib/.
You can configure where Forge looks for both dependencies and contracts using the --lib-paths and --contracts flags respectively. Alternatively you can configure it in foundry.toml.

Combined with remappings, this gives you the flexibility needed to support the project structure of other toolchains such as Hardhat and Truffle.

For automatic Hardhat support you can also pass the --hh flag, which sets the following flags: --lib-paths node_modules --contracts contracts.

Configuration Inheritance
Foundry supports configuration inheritance through the extends field in foundry.toml. This allows you to maintain a base configuration file that can be shared across multiple projects or profiles.

Basic Usage
In your foundry.toml, you can specify a base configuration file to inherit from using either a simple string or an object format:


# Simple string format (uses default "extend-arrays" strategy)
[profile.default]
extends = "./base-config.toml"
src = "src"
test = "test"
Or with an explicit merge strategy:


# Object format with strategy
[profile.default]
extends = { path = "./base-config.toml", strategy = "replace-arrays" }
src = "src"
test = "test"
The base configuration file (base-config.toml) can contain any valid Foundry configuration:


[profile.default]
solc = "0.8.23"
optimizer = true
optimizer_runs = 200
Precedence Rules
Configuration values are resolved with the following precedence (highest to lowest):

Environment variables - Always take the highest priority
Local foundry.toml - Values in your project's main config file
Base/inherited file - Values from the file specified in extends
Merge Strategies
You can control how configuration is merged by specifying a strategy in the object format:


[profile.default]
extends = { path = "./base-config.toml", strategy = "extend-arrays" }
Available strategies:

extend-arrays (default): Arrays are concatenated (base elements + local elements), other values are replaced
replace-arrays: Arrays are replaced entirely by local arrays, other values are replaced
no-collision: Throws an error if any keys exist in both the base and local files
Profile-Specific Inheritance
Each profile can inherit from a different configuration file:


[profile.default]
extends = "./base-config.toml"

[profile.production]
extends = "./production-base.toml"

High-level map (what lives where)

src/ → your actual contracts (e.g., DecentralizedStableCoin.sol, DSCEngine.sol, libraries/OracleLib.sol). This is the default contracts dir.
getfoundry.sh

test/ → all Solidity tests. Use *.t.sol and group by style:

unit/ → fast, focused tests (often with mocks/ under here).

fuzz/ → property/fuzz tests (randomized inputs).

continueOnRevert/ & failOnRevert/ → two invariant suites with different policies when calls revert (common pattern when doing stateful invariant testing with handlers). In Foundry, invariants are tests that must hold across sequences of calls.
getfoundry.sh
+2
getfoundry.sh
+2

script/ → deploy & maintenance scripts (e.g., DeployDSC.s.sol, HelperConfig.s.sol). You run these with forge script … and add --broadcast to actually send txns.
getfoundry.sh
+1

lib/ → dependencies added as git submodules/remappings:

forge-std/ → test base + cheatcodes (vm, asserts, logs).
getfoundry.sh
+1

openzeppelin-contracts/ → ERCs, Ownable, utils, etc.
OpenZeppelin Docs

chainlink-brownie-contracts/ → lightweight Chainlink contracts mirror (price feeds, VRF interfaces, etc.).
GitHub

Manage these with submodules (git submodule …) or forge install. Foundry’s layout expects deps in lib/.
getfoundry.sh
+1

audits/ & codehawks-*.md → notes/reports; purely docs (not a Foundry thing).

.github/ → CI workflows.

Root config files

foundry.toml → all your Foundry config (paths, profiles, fuzz/invariant settings, remappings, etherscan keys, etc.).
getfoundry.sh

.gitmodules → tracks the submodules under lib/.
Git

slither.config.json → static-analysis settings; Slither auto-detects this filename.
GitHub

Makefile, README.md, report.md, .gitignore → quality-of-life & docs.

How you work with it (end-to-end flow)

Get deps in

git submodule update --init --recursive


(Initializes and pulls everything under lib/.)
Git

Build & test

forge build
forge test -vvv                      # all tests
forge test --match-path test/unit/** # just unit tests
forge test --match-path test/fuzz/** # just fuzz tests
# invariants: pick the suite you want
forge test --match-path test/failOnRevert/** -vvvv
forge test --match-path test/continueOnRevert/** -vvvv


Foundry treats any function starting with test* as a test; test files usually end in .t.sol.
getfoundry.sh
+1

Run deploy scripts

forge script script/DeployDSC.s.sol \
  --rpc-url $RPC_URL --broadcast


forge script builds txs; --broadcast actually sends them.
getfoundry.sh
+1

Static analysis (optional but clutch)

slither .


Slither will pick up slither.config.json automatically.
GitHub

Naming & structure tips (so it stays clean)

Keep 1:1 test files with contracts: DSCEngineTest.t.sol, DecentralizedStableCoinTest.t.sol, etc. Split big suites like MyContract.owner.t.sol, MyContract.deposits.t.sol if needed.
getfoundry.sh

Put mocks under test/mocks/ (you already did).

Keep invariant harnesses in their own dirs (your continueOnRevert/ vs failOnRevert/ separation is a solid pattern). Foundry supports stateful invariant testing + handler contracts out of the box.
getfoundry.sh

Centralize config (RPC URLs, explorers, remappings, fuzz/invariant params) in foundry.toml profiles (e.g., default, ci).
getfoundry.sh

Quick mental model

src/ = production code

test/ = prove it works (unit, fuzz, invariants)

script/ = move it onchain

lib/ = third-party code pinned via submodules

root configs = how all of the above behave

You can configure Foundry's behavior using foundry.toml. Configuration can be extended from base files using the extends field (see Configuration Inheritance below for details).
Remappings are specified in remappings.txt.
The default directory for contracts is src/.
The default directory for tests is test/, where any contract with a function that starts with test is considered to be a test.
Dependencies are stored as git submodules in lib/.
You can configure where Forge looks for both dependencies and contracts using the --lib-paths and --contracts flags respectively. Alternatively you can configure it in foundry.toml.

Combined with remappings, this gives you the flexibility needed to support the project structure of other toolchains such as Hardhat and Truffle.

For automatic Hardhat support you can also pass the --hh flag, which sets the following flags: --lib-paths node_modules --contracts contracts.

Configuration Inheritance
Foundry supports configuration inheritance through the extends field in foundry.toml. This allows you to maintain a base configuration file that can be shared across multiple projects or profiles.

Basic Usage
In your foundry.toml, you can specify a base configuration file to inherit from using either a simple string or an object format:


# Simple string format (uses default "extend-arrays" strategy)
[profile.default]
extends = "./base-config.toml"
src = "src"
test = "test"
Or with an explicit merge strategy:


# Object format with strategy
[profile.default]
extends = { path = "./base-config.toml", strategy = "replace-arrays" }
src = "src"
test = "test"
The base configuration file (base-config.toml) can contain any valid Foundry configuration:


[profile.default]
solc = "0.8.23"
optimizer = true
optimizer_runs = 200
Precedence Rules
Configuration values are resolved with the following precedence (highest to lowest):

Environment variables - Always take the highest priority
Local foundry.toml - Values in your project's main config file
Base/inherited file - Values from the file specified in extends
Merge Strategies
You can control how configuration is merged by specifying a strategy in the object format:


[profile.default]
extends = { path = "./base-config.toml", strategy = "extend-arrays" }
Available strategies:

extend-arrays (default): Arrays are concatenated (base elements + local elements), other values are replaced
replace-arrays: Arrays are replaced entirely by local arrays, other values are replaced
no-collision: Throws an error if any keys exist in both the base and local files
Profile-Specific Inheritance
Each profile can inherit from a different configuration file:


[profile.default]
extends = "./base-config.toml"

[profile.production]
extends = "./production-base.toml"

Usage: cast [OPTIONS] <COMMAND>

Commands:
  4byte                  Get the function signatures for the given selector from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4, 4b]
  4byte-calldata         Decode ABI-encoded calldata using
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4c, 4bc]
  4byte-event            Get the event signature for a given topic 0 from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4e, 4be,
                         topic0-event, t0e]
  abi-encode             ABI encode the given function argument, excluding the
                         selector [aliases: ae]
  abi-encode-event       ABI encode an event and its arguments to generate
                         topics and data [aliases: aee]
  access-list            Create an access list for a transaction [aliases: ac,
                         acl]
  address-zero           Prints the zero address [aliases: --address-zero, az]
  admin                  Fetch the EIP-1967 admin account [aliases: adm]
  age                    Get the timestamp of a block [aliases: a]
  artifact               Generate an artifact file, that can be used to deploy a
                         contract locally [aliases: ar]
  b2e-payload            Convert Beacon payload to execution payload [aliases:
                         b2e]
  balance                Get the balance of an account in wei [aliases: b]
  base-fee               Get the basefee of a block [aliases: ba, fee, basefee]
  bind                   Generate a rust binding from a given ABI [aliases: bi]
  block                  Get information about a block [aliases: bl]
  block-number           Get the latest block number [aliases: bn]
  call                   Perform a call on an account without publishing a
                         transaction [aliases: c]
  calldata               ABI-encode a function with arguments [aliases: cd]
  chain                  Get the symbolic name of the current chain
  chain-id               Get the Ethereum chain ID [aliases: ci, cid]
  client                 Get the current client version [aliases: cl]
  code                   Get the runtime bytecode of a contract [aliases: co]
  codehash               Get the codehash for an account
  codesize               Get the runtime bytecode size of a contract [aliases:
                         cs]
  completions            Generate shell completions script [aliases: com]
  compute-address        Compute the contract address from a given nonce and
                         deployer address [aliases: ca]
  concat-hex             Concatenate hex strings [aliases: --concat-hex, ch]
  constructor-args       Display constructor arguments used for the contract
                         initialization [aliases: cra]
  create2                Generate a deterministic contract address using CREATE2
                         [aliases: c2]
  creation-code          Download a contract creation code from Etherscan and
                         RPC [aliases: cc]
  da-estimate            Estimates the data availability size of a given opstack
                         block
  decode-abi             Decode ABI-encoded input or output data [aliases:
                         abi-decode, --abi-decode, ad]
  decode-calldata        Decode ABI-encoded input data [aliases:
                         calldata-decode, --calldata-decode, cdd]
  decode-error           Decode custom error data [aliases: error-decode,
                         --error-decode, erd]
  decode-event           Decode event data [aliases: event-decode,
                         --event-decode, ed]
  decode-string          Decode ABI-encoded string [aliases: string-decode,
                         --string-decode, sd]
  decode-transaction     Decodes a raw signed EIP 2718 typed transaction
                         [aliases: dt, decode-tx]
  disassemble            Disassembles a hex-encoded bytecode into a
                         human-readable representation [aliases: da]
  estimate               Estimate the gas cost of a transaction [aliases: e]
  find-block             Get the block number closest to the provided timestamp
                         [aliases: f]
  format-bytes32-string  Formats a string into bytes32 encoding [aliases:
                         --format-bytes32-string]
  format-units           Format a number from smallest unit to decimal with
                         arbitrary decimals [aliases: --format-units, fun]
  from-bin               Convert binary data into hex data [aliases: --from-bin,
                         from-binx, fb]
  from-fixed-point       Convert a fixed point number into an integer [aliases:
                         --from-fix, ff]
  from-rlp               Decodes RLP hex-encoded data [aliases: --from-rlp]
  from-utf8              Convert UTF8 text to hex [aliases: --from-ascii,
                         --from-utf8, from-ascii, fu, fa]
  from-wei               Convert wei into an ETH amount [aliases: --from-wei,
                         fw]
  gas-price              Get the current gas price [aliases: g]
  hash-message           Hash a message according to EIP-191 [aliases:
                         --hash-message, hm]
  hash-zero              Prints the zero hash [aliases: --hash-zero, hz]
  help                   Print this message or the help of the given
                         subcommand(s)
  implementation         Fetch the EIP-1967 implementation for a contract Can
                         read from the implementation slot or the beacon slot
                         [aliases: impl]
  index                  Compute the storage slot for an entry in a mapping
                         [aliases: in]
  index-erc7201          Compute storage slots as specified by `ERC-7201:
                         Namespaced Storage Layout` [aliases: index7201, in7201]
  interface              Generate a Solidity interface from a given ABI
                         [aliases: i]
  keccak                 Hash arbitrary data using Keccak-256 [aliases: k,
                         keccak256]
  logs                   Get logs by signature or topic [aliases: l]
  lookup-address         Perform an ENS reverse lookup [aliases: la]
  max-int                Prints the maximum value of the given integer type
                         [aliases: --max-int, maxi]
  max-uint               Prints the maximum value of the given integer type
                         [aliases: --max-uint, maxu]
  min-int                Prints the minimum value of the given integer type
                         [aliases: --min-int, mini]
  mktx                   Build and sign a transaction [aliases: m]
  namehash               Calculate the ENS namehash of a name [aliases: na, nh]
  nonce                  Get the nonce for an account [aliases: n]
  pad                    Pads hex data to a specified length [aliases: pd]
  parse-bytes32-address  Parses a checksummed address from bytes32 encoding.
                         [aliases: --parse-bytes32-address]
  parse-bytes32-string   Parses a string from bytes32 encoding [aliases:
                         --parse-bytes32-string]
  parse-units            Convert a number from decimal to smallest unit with
                         arbitrary decimals [aliases: --parse-units, pun]
  pretty-calldata        Pretty print calldata [aliases: pc]
  proof                  Generate a storage proof for a given storage slot
                         [aliases: pr]
  publish                Publish a raw transaction to the network [aliases: p]
  receipt                Get the transaction receipt for a transaction [aliases:
                         re]
  recover-authority      Recovery an EIP-7702 authority from a Authorization
                         JSON string [aliases: decode-auth]
  resolve-name           Perform an ENS lookup [aliases: rn]
  rpc                    Perform a raw JSON-RPC request [aliases: rp]
  run                    Runs a published transaction in a local environment and
                         prints the trace [aliases: r]
  selectors              Extracts function selectors and arguments from bytecode
                         [aliases: sel]
  send                   Sign and publish a transaction [aliases: s]
  shl                    Perform a left shifting operation
  shr                    Perform a right shifting operation
  sig                    Get the selector for a function [aliases: si]
  sig-event              Generate event signatures from event string [aliases:
                         se]
  source                 Get the source code of a contract from a block explorer
                         [aliases: et, src]
  storage                Get the raw value of a contract's storage slot
                         [aliases: st]
  storage-root           Get the storage root for an account [aliases: sr]
  to-ascii               Convert hex data to an ASCII string [aliases:
                         --to-ascii, tas, 2as]
  to-base                Converts a number of one base to another [aliases:
                         --to-base, --to-radix, to-radix, tr, 2r]
  to-bytes32             Right-pads hex data to 32 bytes [aliases: --to-bytes32,
                         tb, 2b]
  to-check-sum-address   Convert an address to a checksummed format (EIP-55)
                         [aliases: --to-checksum-address, --to-checksum,
                         to-checksum, ta, 2a]
  to-dec                 Converts a number of one base to decimal [aliases:
                         --to-dec, td, 2d]
  to-fixed-point         Convert an integer into a fixed point number [aliases:
                         --to-fix, tf, 2f]
  to-hex                 Converts a number of one base to another [aliases:
                         --to-hex, th, 2h]
  to-hexdata             Normalize the input to lowercase, 0x-prefixed hex
                         [aliases: --to-hexdata, thd, 2hd]
  to-int256              Convert a number to a hex-encoded int256 [aliases:
                         --to-int256, ti, 2i]
  to-rlp                 RLP encodes hex data, or an array of hex data [aliases:
                         --to-rlp]
  to-uint256             Convert a number to a hex-encoded uint256 [aliases:
                         --to-uint256, tu, 2u]
  to-unit                Convert an ETH amount into another unit (ether, gwei or
                         wei) [aliases: --to-unit, tun, 2un]
  to-utf8                Convert hex data to a utf-8 string [aliases: --to-utf8,
                         tu8, 2u8]
  to-wei                 Convert an ETH amount to wei [aliases: --to-wei, tw,
                         2w]
  tx                     Get information about a transaction [aliases: t]
  tx-pool                Inspect the TxPool of a node [aliases: tp]
  upload-signature       Upload the given signatures to [https://openchain.xyz](https://openchain.xyz)
                         [aliases: ups]
  wallet                 Wallet management utilities [aliases: w]

Options:
  -h, --help
          Print help (see a summary with '-h')

  -j, --threads <THREADS>
          Number of threads to use. Specifying 0 defaults to the number of
          logical cores

          [aliases: --jobs]

  -V, --version
          Print version

Display options:
      --color <COLOR>
          The color of the log messages

          Possible values:
          - auto:   Intelligently guess whether to use color output (default)
          - always: Force color output
          - never:  Force disable color output

      --json
          Format log messages as JSON

      --md
          Format log messages as Markdown

  -q, --quiet
          Do not print log messages

  -v, --verbosity...
          Verbosity level of the log messages.

          Pass multiple times to increase the verbosity (e.g. -v, -vv, -vvv).

          Depending on the context the verbosity levels have different meanings.

          For example, the verbosity levels of the EVM are:
          - 2 (-vv): Print logs for all tests.
          - 3 (-vvv): Print execution traces for failing tests.
          - 4 (-vvvv): Print execution traces for all tests, and setup traces
          for failing tests.
          - 5 (-vvvvv): Print execution and setup traces for all tests,
          including storage changes and
            backtraces with line numbers.

Find more information in the book: https://getfoundry.sh/cast/overview

Usage: cast [OPTIONS] <COMMAND>

Commands:
  4byte                  Get the function signatures for the given selector from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4, 4b]
  4byte-calldata         Decode ABI-encoded calldata using
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4c, 4bc]
  4byte-event            Get the event signature for a given topic 0 from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4e, 4be,
                         topic0-event, t0e]
  abi-encode             ABI encode the given function argument, excluding the
                         selector [aliases: ae]
  abi-encode-event       ABI encode an event and its arguments to generate
                         topics and data [aliases: aee]
  access-list            Create an access list for a transaction [aliases: ac,
                         acl]
  address-zero           Prints the zero address [aliases: --address-zero, az]
  admin                  Fetch the EIP-1967 admin account [aliases: adm]
  age                    Get the timestamp of a block [aliases: a]
  artifact               Generate an artifact file, that can be used to deploy a
                         contract locally [aliases: ar]
  b2e-payload            Convert Beacon payload to execution payload [aliases:
                         b2e]
  balance                Get the balance of an account in wei [aliases: b]
  base-fee               Get the basefee of a block [aliases: ba, fee, basefee]
  bind                   Generate a rust binding from a given ABI [aliases: bi]
  block                  Get information about a block [aliases: bl]
  block-number           Get the latest block number [aliases: bn]
  call                   Perform a call on an account without publishing a
                         transaction [aliases: c]
  calldata               ABI-encode a function with arguments [aliases: cd]
  chain                  Get the symbolic name of the current chain
  chain-id               Get the Ethereum chain ID [aliases: ci, cid]
  client                 Get the current client version [aliases: cl]
  code                   Get the runtime bytecode of a contract [aliases: co]
  codehash               Get the codehash for an account
  codesize               Get the runtime bytecode size of a contract [aliases:
                         cs]
  completions            Generate shell completions script [aliases: com]
  compute-address        Compute the contract address from a given nonce and
                         deployer address [aliases: ca]
  concat-hex             Concatenate hex strings [aliases: --concat-hex, ch]
  constructor-args       Display constructor arguments used for the contract
                         initialization [aliases: cra]
  create2                Generate a deterministic contract address using CREATE2
                         [aliases: c2]
  creation-code          Download a contract creation code from Etherscan and
                         RPC [aliases: cc]
  da-estimate            Estimates the data availability size of a given opstack
                         block
  decode-abi             Decode ABI-encoded input or output data [aliases:
                         abi-decode, --abi-decode, ad]
  decode-calldata        Decode ABI-encoded input data [aliases:
                         calldata-decode, --calldata-decode, cdd]
  decode-error           Decode custom error data [aliases: error-decode,
                         --error-decode, erd]
  decode-event           Decode event data [aliases: event-decode,
                         --event-decode, ed]
  decode-string          Decode ABI-encoded string [aliases: string-decode,
                         --string-decode, sd]
  decode-transaction     Decodes a raw signed EIP 2718 typed transaction
                         [aliases: dt, decode-tx]
  disassemble            Disassembles a hex-encoded bytecode into a
                         human-readable representation [aliases: da]
  estimate               Estimate the gas cost of a transaction [aliases: e]
  find-block             Get the block number closest to the provided timestamp
                         [aliases: f]
  format-bytes32-string  Formats a string into bytes32 encoding [aliases:
                         --format-bytes32-string]
  format-units           Format a number from smallest unit to decimal with
                         arbitrary decimals [aliases: --format-units, fun]
  from-bin               Convert binary data into hex data [aliases: --from-bin,
                         from-binx, fb]
  from-fixed-point       Convert a fixed point number into an integer [aliases:
                         --from-fix, ff]
  from-rlp               Decodes RLP hex-encoded data [aliases: --from-rlp]
  from-utf8              Convert UTF8 text to hex [aliases: --from-ascii,
                         --from-utf8, from-ascii, fu, fa]
  from-wei               Convert wei into an ETH amount [aliases: --from-wei,
                         fw]
  gas-price              Get the current gas price [aliases: g]
  hash-message           Hash a message according to EIP-191 [aliases:
                         --hash-message, hm]
  hash-zero              Prints the zero hash [aliases: --hash-zero, hz]
  help                   Print this message or the help of the given
                         subcommand(s)
  implementation         Fetch the EIP-1967 implementation for a contract Can
                         read from the implementation slot or the beacon slot
                         [aliases: impl]
  index                  Compute the storage slot for an entry in a mapping
                         [aliases: in]
  index-erc7201          Compute storage slots as specified by `ERC-7201:
                         Namespaced Storage Layout` [aliases: index7201, in7201]
  interface              Generate a Solidity interface from a given ABI
                         [aliases: i]
  keccak                 Hash arbitrary data using Keccak-256 [aliases: k,
                         keccak256]
  logs                   Get logs by signature or topic [aliases: l]
  lookup-address         Perform an ENS reverse lookup [aliases: la]
  max-int                Prints the maximum value of the given integer type
                         [aliases: --max-int, maxi]
  max-uint               Prints the maximum value of the given integer type
                         [aliases: --max-uint, maxu]
  min-int                Prints the minimum value of the given integer type
                         [aliases: --min-int, mini]
  mktx                   Build and sign a transaction [aliases: m]
  namehash               Calculate the ENS namehash of a name [aliases: na, nh]
  nonce                  Get the nonce for an account [aliases: n]
  pad                    Pads hex data to a specified length [aliases: pd]
  parse-bytes32-address  Parses a checksummed address from bytes32 encoding.
                         [aliases: --parse-bytes32-address]
  parse-bytes32-string   Parses a string from bytes32 encoding [aliases:
                         --parse-bytes32-string]
  parse-units            Convert a number from decimal to smallest unit with
                         arbitrary decimals [aliases: --parse-units, pun]
  pretty-calldata        Pretty print calldata [aliases: pc]
  proof                  Generate a storage proof for a given storage slot
                         [aliases: pr]
  publish                Publish a raw transaction to the network [aliases: p]
  receipt                Get the transaction receipt for a transaction [aliases:
                         re]
  recover-authority      Recovery an EIP-7702 authority from a Authorization
                         JSON string [aliases: decode-auth]
  resolve-name           Perform an ENS lookup [aliases: rn]
  rpc                    Perform a raw JSON-RPC request [aliases: rp]
  run                    Runs a published transaction in a local environment and
                         prints the trace [aliases: r]
  selectors              Extracts function selectors and arguments from bytecode
                         [aliases: sel]
  send                   Sign and publish a transaction [aliases: s]
  shl                    Perform a left shifting operation
  shr                    Perform a right shifting operation
  sig                    Get the selector for a function [aliases: si]
  sig-event              Generate event signatures from event string [aliases:
                         se]
  source                 Get the source code of a contract from a block explorer
                         [aliases: et, src]
  storage                Get the raw value of a contract's storage slot
                         [aliases: st]
  storage-root           Get the storage root for an account [aliases: sr]
  to-ascii               Convert hex data to an ASCII string [aliases:
                         --to-ascii, tas, 2as]
  to-base                Converts a number of one base to another [aliases:
                         --to-base, --to-radix, to-radix, tr, 2r]
  to-bytes32             Right-pads hex data to 32 bytes [aliases: --to-bytes32,
                         tb, 2b]
  to-check-sum-address   Convert an address to a checksummed format (EIP-55)
                         [aliases: --to-checksum-address, --to-checksum,
                         to-checksum, ta, 2a]
  to-dec                 Converts a number of one base to decimal [aliases:
                         --to-dec, td, 2d]
  to-fixed-point         Convert an integer into a fixed point number [aliases:
                         --to-fix, tf, 2f]
  to-hex                 Converts a number of one base to another [aliases:
                         --to-hex, th, 2h]
  to-hexdata             Normalize the input to lowercase, 0x-prefixed hex
                         [aliases: --to-hexdata, thd, 2hd]
  to-int256              Convert a number to a hex-encoded int256 [aliases:
                         --to-int256, ti, 2i]
  to-rlp                 RLP encodes hex data, or an array of hex data [aliases:
                         --to-rlp]
  to-uint256             Convert a number to a hex-encoded uint256 [aliases:
                         --to-uint256, tu, 2u]
  to-unit                Convert an ETH amount into another unit (ether, gwei or
                         wei) [aliases: --to-unit, tun, 2un]
  to-utf8                Convert hex data to a utf-8 string [aliases: --to-utf8,
                         tu8, 2u8]
  to-wei                 Convert an ETH amount to wei [aliases: --to-wei, tw,
                         2w]
  tx                     Get information about a transaction [aliases: t]
  tx-pool                Inspect the TxPool of a node [aliases: tp]
  upload-signature       Upload the given signatures to [https://openchain.xyz](https://openchain.xyz)
                         [aliases: ups]
  wallet                 Wallet management utilities [aliases: w]

Options:
  -h, --help
          Print help (see a summary with '-h')

  -j, --threads <THREADS>
          Number of threads to use. Specifying 0 defaults to the number of
          logical cores

          [aliases: --jobs]

  -V, --version
          Print version

Display options:
      --color <COLOR>
          The color of the log messages

          Possible values:
          - auto:   Intelligently guess whether to use color output (default)
          - always: Force color output
          - never:  Force disable color output

      --json
          Format log messages as JSON

      --md
          Format log messages as Markdown

  -q, --quiet
          Do not print log messages

  -v, --verbosity...
          Verbosity level of the log messages.

          Pass multiple times to increase the verbosity (e.g. -v, -vv, -vvv).

          Depending on the context the verbosity levels have different meanings.

          For example, the verbosity levels of the EVM are:
          - 2 (-vv): Print logs for all tests.
          - 3 (-vvv): Print execution traces for failing tests.
          - 4 (-vvvv): Print execution traces for all tests, and setup traces
          for failing tests.
          - 5 (-vvvvv): Print execution and setup traces for all tests,
          including storage changes and
            backtraces with line numbers.

Find more information in the book: https://getfoundry.sh/cast/overview

Usage: cast [OPTIONS] <COMMAND>

Commands:
  4byte                  Get the function signatures for the given selector from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4, 4b]
  4byte-calldata         Decode ABI-encoded calldata using
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4c, 4bc]
  4byte-event            Get the event signature for a given topic 0 from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4e, 4be,
                         topic0-event, t0e]
  abi-encode             ABI encode the given function argument, excluding the
                         selector [aliases: ae]
  abi-encode-event       ABI encode an event and its arguments to generate
                         topics and data [aliases: aee]
  access-list            Create an access list for a transaction [aliases: ac,
                         acl]
  address-zero           Prints the zero address [aliases: --address-zero, az]
  admin                  Fetch the EIP-1967 admin account [aliases: adm]
  age                    Get the timestamp of a block [aliases: a]
  artifact               Generate an artifact file, that can be used to deploy a
                         contract locally [aliases: ar]
  b2e-payload            Convert Beacon payload to execution payload [aliases:
                         b2e]
  balance                Get the balance of an account in wei [aliases: b]
  base-fee               Get the basefee of a block [aliases: ba, fee, basefee]
  bind                   Generate a rust binding from a given ABI [aliases: bi]
  block                  Get information about a block [aliases: bl]
  block-number           Get the latest block number [aliases: bn]
  call                   Perform a call on an account without publishing a
                         transaction [aliases: c]
  calldata               ABI-encode a function with arguments [aliases: cd]
  chain                  Get the symbolic name of the current chain
  chain-id               Get the Ethereum chain ID [aliases: ci, cid]
  client                 Get the current client version [aliases: cl]
  code                   Get the runtime bytecode of a contract [aliases: co]
  codehash               Get the codehash for an account
  codesize               Get the runtime bytecode size of a contract [aliases:
                         cs]
  completions            Generate shell completions script [aliases: com]
  compute-address        Compute the contract address from a given nonce and
                         deployer address [aliases: ca]
  concat-hex             Concatenate hex strings [aliases: --concat-hex, ch]
  constructor-args       Display constructor arguments used for the contract
                         initialization [aliases: cra]
  create2                Generate a deterministic contract address using CREATE2
                         [aliases: c2]
  creation-code          Download a contract creation code from Etherscan and
                         RPC [aliases: cc]
  da-estimate            Estimates the data availability size of a given opstack
                         block
  decode-abi             Decode ABI-encoded input or output data [aliases:
                         abi-decode, --abi-decode, ad]
  decode-calldata        Decode ABI-encoded input data [aliases:
                         calldata-decode, --calldata-decode, cdd]
  decode-error           Decode custom error data [aliases: error-decode,
                         --error-decode, erd]
  decode-event           Decode event data [aliases: event-decode,
                         --event-decode, ed]
  decode-string          Decode ABI-encoded string [aliases: string-decode,
                         --string-decode, sd]
  decode-transaction     Decodes a raw signed EIP 2718 typed transaction
                         [aliases: dt, decode-tx]
  disassemble            Disassembles a hex-encoded bytecode into a
                         human-readable representation [aliases: da]
  estimate               Estimate the gas cost of a transaction [aliases: e]
  find-block             Get the block number closest to the provided timestamp
                         [aliases: f]
  format-bytes32-string  Formats a string into bytes32 encoding [aliases:
                         --format-bytes32-string]
  format-units           Format a number from smallest unit to decimal with
                         arbitrary decimals [aliases: --format-units, fun]
  from-bin               Convert binary data into hex data [aliases: --from-bin,
                         from-binx, fb]
  from-fixed-point       Convert a fixed point number into an integer [aliases:
                         --from-fix, ff]
  from-rlp               Decodes RLP hex-encoded data [aliases: --from-rlp]
  from-utf8              Convert UTF8 text to hex [aliases: --from-ascii,
                         --from-utf8, from-ascii, fu, fa]
  from-wei               Convert wei into an ETH amount [aliases: --from-wei,
                         fw]
  gas-price              Get the current gas price [aliases: g]
  hash-message           Hash a message according to EIP-191 [aliases:
                         --hash-message, hm]
  hash-zero              Prints the zero hash [aliases: --hash-zero, hz]
  help                   Print this message or the help of the given
                         subcommand(s)
  implementation         Fetch the EIP-1967 implementation for a contract Can
                         read from the implementation slot or the beacon slot
                         [aliases: impl]
  index                  Compute the storage slot for an entry in a mapping
                         [aliases: in]
  index-erc7201          Compute storage slots as specified by `ERC-7201:
                         Namespaced Storage Layout` [aliases: index7201, in7201]
  interface              Generate a Solidity interface from a given ABI
                         [aliases: i]
  keccak                 Hash arbitrary data using Keccak-256 [aliases: k,
                         keccak256]
  logs                   Get logs by signature or topic [aliases: l]
  lookup-address         Perform an ENS reverse lookup [aliases: la]
  max-int                Prints the maximum value of the given integer type
                         [aliases: --max-int, maxi]
  max-uint               Prints the maximum value of the given integer type
                         [aliases: --max-uint, maxu]
  min-int                Prints the minimum value of the given integer type
                         [aliases: --min-int, mini]
  mktx                   Build and sign a transaction [aliases: m]
  namehash               Calculate the ENS namehash of a name [aliases: na, nh]
  nonce                  Get the nonce for an account [aliases: n]
  pad                    Pads hex data to a specified length [aliases: pd]
  parse-bytes32-address  Parses a checksummed address from bytes32 encoding.
                         [aliases: --parse-bytes32-address]
  parse-bytes32-string   Parses a string from bytes32 encoding [aliases:
                         --parse-bytes32-string]
  parse-units            Convert a number from decimal to smallest unit with
                         arbitrary decimals [aliases: --parse-units, pun]
  pretty-calldata        Pretty print calldata [aliases: pc]
  proof                  Generate a storage proof for a given storage slot
                         [aliases: pr]
  publish                Publish a raw transaction to the network [aliases: p]
  receipt                Get the transaction receipt for a transaction [aliases:
                         re]
  recover-authority      Recovery an EIP-7702 authority from a Authorization
                         JSON string [aliases: decode-auth]
  resolve-name           Perform an ENS lookup [aliases: rn]
  rpc                    Perform a raw JSON-RPC request [aliases: rp]
  run                    Runs a published transaction in a local environment and
                         prints the trace [aliases: r]
  selectors              Extracts function selectors and arguments from bytecode
                         [aliases: sel]
  send                   Sign and publish a transaction [aliases: s]
  shl                    Perform a left shifting operation
  shr                    Perform a right shifting operation
  sig                    Get the selector for a function [aliases: si]
  sig-event              Generate event signatures from event string [aliases:
                         se]
  source                 Get the source code of a contract from a block explorer
                         [aliases: et, src]
  storage                Get the raw value of a contract's storage slot
                         [aliases: st]
  storage-root           Get the storage root for an account [aliases: sr]
  to-ascii               Convert hex data to an ASCII string [aliases:
                         --to-ascii, tas, 2as]
  to-base                Converts a number of one base to another [aliases:
                         --to-base, --to-radix, to-radix, tr, 2r]
  to-bytes32             Right-pads hex data to 32 bytes [aliases: --to-bytes32,
                         tb, 2b]
  to-check-sum-address   Convert an address to a checksummed format (EIP-55)
                         [aliases: --to-checksum-address, --to-checksum,
                         to-checksum, ta, 2a]
  to-dec                 Converts a number of one base to decimal [aliases:
                         --to-dec, td, 2d]
  to-fixed-point         Convert an integer into a fixed point number [aliases:
                         --to-fix, tf, 2f]
  to-hex                 Converts a number of one base to another [aliases:
                         --to-hex, th, 2h]
  to-hexdata             Normalize the input to lowercase, 0x-prefixed hex
                         [aliases: --to-hexdata, thd, 2hd]
  to-int256              Convert a number to a hex-encoded int256 [aliases:
                         --to-int256, ti, 2i]
  to-rlp                 RLP encodes hex data, or an array of hex data [aliases:
                         --to-rlp]
  to-uint256             Convert a number to a hex-encoded uint256 [aliases:
                         --to-uint256, tu, 2u]
  to-unit                Convert an ETH amount into another unit (ether, gwei or
                         wei) [aliases: --to-unit, tun, 2un]
  to-utf8                Convert hex data to a utf-8 string [aliases: --to-utf8,
                         tu8, 2u8]
  to-wei                 Convert an ETH amount to wei [aliases: --to-wei, tw,
                         2w]
  tx                     Get information about a transaction [aliases: t]
  tx-pool                Inspect the TxPool of a node [aliases: tp]
  upload-signature       Upload the given signatures to [https://openchain.xyz](https://openchain.xyz)
                         [aliases: ups]
  wallet                 Wallet management utilities [aliases: w]

Options:
  -h, --help
          Print help (see a summary with '-h')

  -j, --threads <THREADS>
          Number of threads to use. Specifying 0 defaults to the number of
          logical cores

          [aliases: --jobs]

  -V, --version
          Print version

Display options:
      --color <COLOR>
          The color of the log messages

          Possible values:
          - auto:   Intelligently guess whether to use color output (default)
          - always: Force color output
          - never:  Force disable color output

      --json
          Format log messages as JSON

      --md
          Format log messages as Markdown

  -q, --quiet
          Do not print log messages

  -v, --verbosity...
          Verbosity level of the log messages.

          Pass multiple times to increase the verbosity (e.g. -v, -vv, -vvv).

          Depending on the context the verbosity levels have different meanings.

          For example, the verbosity levels of the EVM are:
          - 2 (-vv): Print logs for all tests.
          - 3 (-vvv): Print execution traces for failing tests.
          - 4 (-vvvv): Print execution traces for all tests, and setup traces
          for failing tests.
          - 5 (-vvvvv): Print execution and setup traces for all tests,
          including storage changes and
            backtraces with line numbers.

Find more information in the book: https://getfoundry.sh/cast/overview

Usage: cast [OPTIONS] <COMMAND>

Commands:
  4byte                  Get the function signatures for the given selector from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4, 4b]
  4byte-calldata         Decode ABI-encoded calldata using
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4c, 4bc]
  4byte-event            Get the event signature for a given topic 0 from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4e, 4be,
                         topic0-event, t0e]
  abi-encode             ABI encode the given function argument, excluding the
                         selector [aliases: ae]
  abi-encode-event       ABI encode an event and its arguments to generate
                         topics and data [aliases: aee]
  access-list            Create an access list for a transaction [aliases: ac,
                         acl]
  address-zero           Prints the zero address [aliases: --address-zero, az]
  admin                  Fetch the EIP-1967 admin account [aliases: adm]
  age                    Get the timestamp of a block [aliases: a]
  artifact               Generate an artifact file, that can be used to deploy a
                         contract locally [aliases: ar]
  b2e-payload            Convert Beacon payload to execution payload [aliases:
                         b2e]
  balance                Get the balance of an account in wei [aliases: b]
  base-fee               Get the basefee of a block [aliases: ba, fee, basefee]
  bind                   Generate a rust binding from a given ABI [aliases: bi]
  block                  Get information about a block [aliases: bl]
  block-number           Get the latest block number [aliases: bn]
  call                   Perform a call on an account without publishing a
                         transaction [aliases: c]
  calldata               ABI-encode a function with arguments [aliases: cd]
  chain                  Get the symbolic name of the current chain
  chain-id               Get the Ethereum chain ID [aliases: ci, cid]
  client                 Get the current client version [aliases: cl]
  code                   Get the runtime bytecode of a contract [aliases: co]
  codehash               Get the codehash for an account
  codesize               Get the runtime bytecode size of a contract [aliases:
                         cs]
  completions            Generate shell completions script [aliases: com]
  compute-address        Compute the contract address from a given nonce and
                         deployer address [aliases: ca]
  concat-hex             Concatenate hex strings [aliases: --concat-hex, ch]
  constructor-args       Display constructor arguments used for the contract
                         initialization [aliases: cra]
  create2                Generate a deterministic contract address using CREATE2
                         [aliases: c2]
  creation-code          Download a contract creation code from Etherscan and
                         RPC [aliases: cc]
  da-estimate            Estimates the data availability size of a given opstack
                         block
  decode-abi             Decode ABI-encoded input or output data [aliases:
                         abi-decode, --abi-decode, ad]
  decode-calldata        Decode ABI-encoded input data [aliases:
                         calldata-decode, --calldata-decode, cdd]
  decode-error           Decode custom error data [aliases: error-decode,
                         --error-decode, erd]
  decode-event           Decode event data [aliases: event-decode,
                         --event-decode, ed]
  decode-string          Decode ABI-encoded string [aliases: string-decode,
                         --string-decode, sd]
  decode-transaction     Decodes a raw signed EIP 2718 typed transaction
                         [aliases: dt, decode-tx]
  disassemble            Disassembles a hex-encoded bytecode into a
                         human-readable representation [aliases: da]
  estimate               Estimate the gas cost of a transaction [aliases: e]
  find-block             Get the block number closest to the provided timestamp
                         [aliases: f]
  format-bytes32-string  Formats a string into bytes32 encoding [aliases:
                         --format-bytes32-string]
  format-units           Format a number from smallest unit to decimal with
                         arbitrary decimals [aliases: --format-units, fun]
  from-bin               Convert binary data into hex data [aliases: --from-bin,
                         from-binx, fb]
  from-fixed-point       Convert a fixed point number into an integer [aliases:
                         --from-fix, ff]
  from-rlp               Decodes RLP hex-encoded data [aliases: --from-rlp]
  from-utf8              Convert UTF8 text to hex [aliases: --from-ascii,
                         --from-utf8, from-ascii, fu, fa]
  from-wei               Convert wei into an ETH amount [aliases: --from-wei,
                         fw]
  gas-price              Get the current gas price [aliases: g]
  hash-message           Hash a message according to EIP-191 [aliases:
                         --hash-message, hm]
  hash-zero              Prints the zero hash [aliases: --hash-zero, hz]
  help                   Print this message or the help of the given
                         subcommand(s)
  implementation         Fetch the EIP-1967 implementation for a contract Can
                         read from the implementation slot or the beacon slot
                         [aliases: impl]
  index                  Compute the storage slot for an entry in a mapping
                         [aliases: in]
  index-erc7201          Compute storage slots as specified by `ERC-7201:
                         Namespaced Storage Layout` [aliases: index7201, in7201]
  interface              Generate a Solidity interface from a given ABI
                         [aliases: i]
  keccak                 Hash arbitrary data using Keccak-256 [aliases: k,
                         keccak256]
  logs                   Get logs by signature or topic [aliases: l]
  lookup-address         Perform an ENS reverse lookup [aliases: la]
  max-int                Prints the maximum value of the given integer type
                         [aliases: --max-int, maxi]
  max-uint               Prints the maximum value of the given integer type
                         [aliases: --max-uint, maxu]
  min-int                Prints the minimum value of the given integer type
                         [aliases: --min-int, mini]
  mktx                   Build and sign a transaction [aliases: m]
  namehash               Calculate the ENS namehash of a name [aliases: na, nh]
  nonce                  Get the nonce for an account [aliases: n]
  pad                    Pads hex data to a specified length [aliases: pd]
  parse-bytes32-address  Parses a checksummed address from bytes32 encoding.
                         [aliases: --parse-bytes32-address]
  parse-bytes32-string   Parses a string from bytes32 encoding [aliases:
                         --parse-bytes32-string]
  parse-units            Convert a number from decimal to smallest unit with
                         arbitrary decimals [aliases: --parse-units, pun]
  pretty-calldata        Pretty print calldata [aliases: pc]
  proof                  Generate a storage proof for a given storage slot
                         [aliases: pr]
  publish                Publish a raw transaction to the network [aliases: p]
  receipt                Get the transaction receipt for a transaction [aliases:
                         re]
  recover-authority      Recovery an EIP-7702 authority from a Authorization
                         JSON string [aliases: decode-auth]
  resolve-name           Perform an ENS lookup [aliases: rn]
  rpc                    Perform a raw JSON-RPC request [aliases: rp]
  run                    Runs a published transaction in a local environment and
                         prints the trace [aliases: r]
  selectors              Extracts function selectors and arguments from bytecode
                         [aliases: sel]
  send                   Sign and publish a transaction [aliases: s]
  shl                    Perform a left shifting operation
  shr                    Perform a right shifting operation
  sig                    Get the selector for a function [aliases: si]
  sig-event              Generate event signatures from event string [aliases:
                         se]
  source                 Get the source code of a contract from a block explorer
                         [aliases: et, src]
  storage                Get the raw value of a contract's storage slot
                         [aliases: st]
  storage-root           Get the storage root for an account [aliases: sr]
  to-ascii               Convert hex data to an ASCII string [aliases:
                         --to-ascii, tas, 2as]
  to-base                Converts a number of one base to another [aliases:
                         --to-base, --to-radix, to-radix, tr, 2r]
  to-bytes32             Right-pads hex data to 32 bytes [aliases: --to-bytes32,
                         tb, 2b]
  to-check-sum-address   Convert an address to a checksummed format (EIP-55)
                         [aliases: --to-checksum-address, --to-checksum,
                         to-checksum, ta, 2a]
  to-dec                 Converts a number of one base to decimal [aliases:
                         --to-dec, td, 2d]
  to-fixed-point         Convert an integer into a fixed point number [aliases:
                         --to-fix, tf, 2f]
  to-hex                 Converts a number of one base to another [aliases:
                         --to-hex, th, 2h]
  to-hexdata             Normalize the input to lowercase, 0x-prefixed hex
                         [aliases: --to-hexdata, thd, 2hd]
  to-int256              Convert a number to a hex-encoded int256 [aliases:
                         --to-int256, ti, 2i]
  to-rlp                 RLP encodes hex data, or an array of hex data [aliases:
                         --to-rlp]
  to-uint256             Convert a number to a hex-encoded uint256 [aliases:
                         --to-uint256, tu, 2u]
  to-unit                Convert an ETH amount into another unit (ether, gwei or
                         wei) [aliases: --to-unit, tun, 2un]
  to-utf8                Convert hex data to a utf-8 string [aliases: --to-utf8,
                         tu8, 2u8]
  to-wei                 Convert an ETH amount to wei [aliases: --to-wei, tw,
                         2w]
  tx                     Get information about a transaction [aliases: t]
  tx-pool                Inspect the TxPool of a node [aliases: tp]
  upload-signature       Upload the given signatures to [https://openchain.xyz](https://openchain.xyz)
                         [aliases: ups]
  wallet                 Wallet management utilities [aliases: w]

Options:
  -h, --help
          Print help (see a summary with '-h')

  -j, --threads <THREADS>
          Number of threads to use. Specifying 0 defaults to the number of
          logical cores

          [aliases: --jobs]

  -V, --version
          Print version

Display options:
      --color <COLOR>
          The color of the log messages

          Possible values:
          - auto:   Intelligently guess whether to use color output (default)
          - always: Force color output
          - never:  Force disable color output

      --json
          Format log messages as JSON

      --md
          Format log messages as Markdown

  -q, --quiet
          Do not print log messages

  -v, --verbosity...
          Verbosity level of the log messages.

          Pass multiple times to increase the verbosity (e.g. -v, -vv, -vvv).

          Depending on the context the verbosity levels have different meanings.

          For example, the verbosity levels of the EVM are:
          - 2 (-vv): Print logs for all tests.
          - 3 (-vvv): Print execution traces for failing tests.
          - 4 (-vvvv): Print execution traces for all tests, and setup traces
          for failing tests.
          - 5 (-vvvvv): Print execution and setup traces for all tests,
          including storage changes and
            backtraces with line numbers.

Find more information in the book: https://getfoundry.sh/cast/overview

Usage: cast [OPTIONS] <COMMAND>

Commands:
  4byte                  Get the function signatures for the given selector from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4, 4b]
  4byte-calldata         Decode ABI-encoded calldata using
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4c, 4bc]
  4byte-event            Get the event signature for a given topic 0 from
                         [https://openchain.xyz](https://openchain.xyz) [aliases: 4e, 4be,
                         topic0-event, t0e]
  abi-encode             ABI encode the given function argument, excluding the
                         selector [aliases: ae]
  abi-encode-event       ABI encode an event and its arguments to generate
                         topics and data [aliases: aee]
  access-list            Create an access list for a transaction [aliases: ac,
                         acl]
  address-zero           Prints the zero address [aliases: --address-zero, az]
  admin                  Fetch the EIP-1967 admin account [aliases: adm]
  age                    Get the timestamp of a block [aliases: a]
  artifact               Generate an artifact file, that can be used to deploy a
                         contract locally [aliases: ar]
  b2e-payload            Convert Beacon payload to execution payload [aliases:
                         b2e]
  balance                Get the balance of an account in wei [aliases: b]
  base-fee               Get the basefee of a block [aliases: ba, fee, basefee]
  bind                   Generate a rust binding from a given ABI [aliases: bi]
  block                  Get information about a block [aliases: bl]
  block-number           Get the latest block number [aliases: bn]
  call                   Perform a call on an account without publishing a
                         transaction [aliases: c]
  calldata               ABI-encode a function with arguments [aliases: cd]
  chain                  Get the symbolic name of the current chain
  chain-id               Get the Ethereum chain ID [aliases: ci, cid]
  client                 Get the current client version [aliases: cl]
  code                   Get the runtime bytecode of a contract [aliases: co]
  codehash               Get the codehash for an account
  codesize               Get the runtime bytecode size of a contract [aliases:
                         cs]
  completions            Generate shell completions script [aliases: com]
  compute-address        Compute the contract address from a given nonce and
                         deployer address [aliases: ca]
  concat-hex             Concatenate hex strings [aliases: --concat-hex, ch]
  constructor-args       Display constructor arguments used for the contract
                         initialization [aliases: cra]
  create2                Generate a deterministic contract address using CREATE2
                         [aliases: c2]
  creation-code          Download a contract creation code from Etherscan and
                         RPC [aliases: cc]
  da-estimate            Estimates the data availability size of a given opstack
                         block
  decode-abi             Decode ABI-encoded input or output data [aliases:
                         abi-decode, --abi-decode, ad]
  decode-calldata        Decode ABI-encoded input data [aliases:
                         calldata-decode, --calldata-decode, cdd]
  decode-error           Decode custom error data [aliases: error-decode,
                         --error-decode, erd]
  decode-event           Decode event data [aliases: event-decode,
                         --event-decode, ed]
  decode-string          Decode ABI-encoded string [aliases: string-decode,
                         --string-decode, sd]
  decode-transaction     Decodes a raw signed EIP 2718 typed transaction
                         [aliases: dt, decode-tx]
  disassemble            Disassembles a hex-encoded bytecode into a
                         human-readable representation [aliases: da]
  estimate               Estimate the gas cost of a transaction [aliases: e]
  find-block             Get the block number closest to the provided timestamp
                         [aliases: f]
  format-bytes32-string  Formats a string into bytes32 encoding [aliases:
                         --format-bytes32-string]
  format-units           Format a number from smallest unit to decimal with
                         arbitrary decimals [aliases: --format-units, fun]
  from-bin               Convert binary data into hex data [aliases: --from-bin,
                         from-binx, fb]
  from-fixed-point       Convert a fixed point number into an integer [aliases:
                         --from-fix, ff]
  from-rlp               Decodes RLP hex-encoded data [aliases: --from-rlp]
  from-utf8              Convert UTF8 text to hex [aliases: --from-ascii,
                         --from-utf8, from-ascii, fu, fa]
  from-wei               Convert wei into an ETH amount [aliases: --from-wei,
                         fw]
  gas-price              Get the current gas price [aliases: g]
  hash-message           Hash a message according to EIP-191 [aliases:
                         --hash-message, hm]
  hash-zero              Prints the zero hash [aliases: --hash-zero, hz]
  help                   Print this message or the help of the given
                         subcommand(s)
  implementation         Fetch the EIP-1967 implementation for a contract Can
                         read from the implementation slot or the beacon slot
                         [aliases: impl]
  index                  Compute the storage slot for an entry in a mapping
                         [aliases: in]
  index-erc7201          Compute storage slots as specified by `ERC-7201:
                         Namespaced Storage Layout` [aliases: index7201, in7201]
  interface              Generate a Solidity interface from a given ABI
                         [aliases: i]
  keccak                 Hash arbitrary data using Keccak-256 [aliases: k,
                         keccak256]
  logs                   Get logs by signature or topic [aliases: l]
  lookup-address         Perform an ENS reverse lookup [aliases: la]
  max-int                Prints the maximum value of the given integer type
                         [aliases: --max-int, maxi]
  max-uint               Prints the maximum value of the given integer type
                         [aliases: --max-uint, maxu]
  min-int                Prints the minimum value of the given integer type
                         [aliases: --min-int, mini]
  mktx                   Build and sign a transaction [aliases: m]
  namehash               Calculate the ENS namehash of a name [aliases: na, nh]
  nonce                  Get the nonce for an account [aliases: n]
  pad                    Pads hex data to a specified length [aliases: pd]
  parse-bytes32-address  Parses a checksummed address from bytes32 encoding.
                         [aliases: --parse-bytes32-address]
  parse-bytes32-string   Parses a string from bytes32 encoding [aliases:
                         --parse-bytes32-string]
  parse-units            Convert a number from decimal to smallest unit with
                         arbitrary decimals [aliases: --parse-units, pun]
  pretty-calldata        Pretty print calldata [aliases: pc]
  proof                  Generate a storage proof for a given storage slot
                         [aliases: pr]
  publish                Publish a raw transaction to the network [aliases: p]
  receipt                Get the transaction receipt for a transaction [aliases:
                         re]
  recover-authority      Recovery an EIP-7702 authority from a Authorization
                         JSON string [aliases: decode-auth]
  resolve-name           Perform an ENS lookup [aliases: rn]
  rpc                    Perform a raw JSON-RPC request [aliases: rp]
  run                    Runs a published transaction in a local environment and
                         prints the trace [aliases: r]
  selectors              Extracts function selectors and arguments from bytecode
                         [aliases: sel]
  send                   Sign and publish a transaction [aliases: s]
  shl                    Perform a left shifting operation
  shr                    Perform a right shifting operation
  sig                    Get the selector for a function [aliases: si]
  sig-event              Generate event signatures from event string [aliases:
                         se]
  source                 Get the source code of a contract from a block explorer
                         [aliases: et, src]
  storage                Get the raw value of a contract's storage slot
                         [aliases: st]
  storage-root           Get the storage root for an account [aliases: sr]
  to-ascii               Convert hex data to an ASCII string [aliases:
                         --to-ascii, tas, 2as]
  to-base                Converts a number of one base to another [aliases:
                         --to-base, --to-radix, to-radix, tr, 2r]
  to-bytes32             Right-pads hex data to 32 bytes [aliases: --to-bytes32,
                         tb, 2b]
  to-check-sum-address   Convert an address to a checksummed format (EIP-55)
                         [aliases: --to-checksum-address, --to-checksum,
                         to-checksum, ta, 2a]
  to-dec                 Converts a number of one base to decimal [aliases:
                         --to-dec, td, 2d]
  to-fixed-point         Convert an integer into a fixed point number [aliases:
                         --to-fix, tf, 2f]
  to-hex                 Converts a number of one base to another [aliases:
                         --to-hex, th, 2h]
  to-hexdata             Normalize the input to lowercase, 0x-prefixed hex
                         [aliases: --to-hexdata, thd, 2hd]
  to-int256              Convert a number to a hex-encoded int256 [aliases:
                         --to-int256, ti, 2i]
  to-rlp                 RLP encodes hex data, or an array of hex data [aliases:
                         --to-rlp]
  to-uint256             Convert a number to a hex-encoded uint256 [aliases:
                         --to-uint256, tu, 2u]
  to-unit                Convert an ETH amount into another unit (ether, gwei or
                         wei) [aliases: --to-unit, tun, 2un]
  to-utf8                Convert hex data to a utf-8 string [aliases: --to-utf8,
                         tu8, 2u8]
  to-wei                 Convert an ETH amount to wei [aliases: --to-wei, tw,
                         2w]
  tx                     Get information about a transaction [aliases: t]
  tx-pool                Inspect the TxPool of a node [aliases: tp]
  upload-signature       Upload the given signatures to [https://openchain.xyz](https://openchain.xyz)
                         [aliases: ups]
  wallet                 Wallet management utilities [aliases: w]

Options:
  -h, --help
          Print help (see a summary with '-h')

  -j, --threads <THREADS>
          Number of threads to use. Specifying 0 defaults to the number of
          logical cores

          [aliases: --jobs]

  -V, --version
          Print version

Display options:
      --color <COLOR>
          The color of the log messages

          Possible values:
          - auto:   Intelligently guess whether to use color output (default)
          - always: Force color output
          - never:  Force disable color output

      --json
          Format log messages as JSON

      --md
          Format log messages as Markdown

  -q, --quiet
          Do not print log messages

  -v, --verbosity...
          Verbosity level of the log messages.

          Pass multiple times to increase the verbosity (e.g. -v, -vv, -vvv).

          Depending on the context the verbosity levels have different meanings.

          For example, the verbosity levels of the EVM are:
          - 2 (-vv): Print logs for all tests.
          - 3 (-vvv): Print execution traces for failing tests.
          - 4 (-vvvv): Print execution traces for all tests, and setup traces
          for failing tests.
          - 5 (-vvvvv): Print execution and setup traces for all tests,
          including storage changes and
            backtraces with line numbers.

Find more information in the book: https://getfoundry.sh/cast/overview

