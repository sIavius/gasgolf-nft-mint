//NFTDropOZ.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.38;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTDrop is ERC721 {
    enum MintPhases {
        Closed,
        Allowlist,
        Public
    }

    struct SaleConfig {
        uint16 maxPublic;
        uint16 maxAllowlist;
        uint64 publicPrice;
        uint64 allowlistPrice;
        uint40 publicStart;
        uint40 allowlistStart;
        bool paused;
    }

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    SaleConfig internal config;

    function defaultStorageRead() public view returns (bool pausedVal, uint40 allowlistStartVal) {
        return (config.paused, config.allowlistStart);
    }

    function currentPhase() public view returns (MintPhases) {
        if (block.timestamp < config.allowlistStart) {
            return MintPhases.Closed;
        } else if (config.allowlistStart <= block.timestamp && block.timestamp < config.publicStart) {
            return MintPhases.Allowlist;
        } else {
            return MintPhases.Public;
        }
    }
}

