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

    function storageRead() internal view {
        assembly {
            let word := sload(0)
            let pausedVal := shr(240, word)
            let allowlistStartVal := shr(200, word)
            allowlistStartVal := and(0xffffffffff, allowlistStartVal) // 0xffffffffff - mask - (1 << w) - 1
            // 0xffffffffff - 2^40 - 1 - 40-bit-number
        }
        return (pausedVal, allowlistStartVal)
    }
}