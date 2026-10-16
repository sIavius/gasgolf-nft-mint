pragma solidity 0.8.37;

// SPDX-License-Identifier: MIT

contract NFTDrop {
    struct SaleConfig {
        uint16 maxPublic;
        uint16 maxAllowlist;
        uint64 publicPrice;
        uint64 allowlistPrice;
        uint40 publicStart;
        uint40 allowlistStart;
        bool paused;
    }

    SaleConfig internal config;

    function storageRead() internal view returns (bool pausedVal, uint40 allowlistStartVal) {
        assembly {
            let word := sload(0)
            pausedVal := shr(240, word)
            allowlistStartVal := shr(200, word)
            allowlistStartVal := and(0xffffffffff, allowlistStartVal) // 0xffffffffff - mask - (1 << w) - 1
            // 0xffffffffff - (2^40 - 1) - 40-bit-number
        }
    }
}