# GasGolf NFT Mint

GasGolf is a Solidity project for exploring how storage layout and mint design affect gas costs in an ERC-721 NFT drop. It uses OpenZeppelin ERC721 as a baseline and Foundry for testing.

## What's implemented

- **Sale phases:** the contract reports Closed, Allowlist, or Public based on the configured start times. Foundry tests cover the phase boundaries, including equal start times.
- **Packed storage:** the sale configuration fits in one storage slot. A Yul reader extracts the pause flag and allowlist start time, and a test compares the result with ordinary Solidity field access.
- **ERC-721 minting:** a test harness calls OpenZeppelin's internal mint function and checks the `Transfer` event, token ownership, and recipient balance.

The Yul reader takes the slot number from `config.slot`. When ERC721 inheritance moved the configuration from slot 0 to slot 6, the reader required no change.

Public sale minting, Merkle allowlist verification, and comparative gas benchmarks are planned. The mint test currently exercises the ERC-721 primitive through the test harness.

## Run locally

With Git and Foundry installed:

```sh
git clone --recurse-submodules https://github.com/sIavius/gasgolf-nft-mint.git
cd gasgolf-nft-mint
forge test
```

To inspect the storage layout or run the same formatting check as CI:

```sh
forge inspect src/NFTDropOZ.sol:NFTDrop storageLayout
forge fmt --check
```
