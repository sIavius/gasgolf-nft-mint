//SaleConfigReader.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.38;

library SaleConfigReader {
    function storageRead(uint256 _slotNumber) internal view returns (bool pausedVal, uint40 allowlistStartVal) {
        assembly {
            let word := sload(_slotNumber)
            pausedVal := and(shr(240, word), 0x00FF) // 0000000011111111 == 0x00FF
            allowlistStartVal := shr(200, word)
            allowlistStartVal := and(0xffffffffff, allowlistStartVal) // 0xffffffffff - mask - (1 << w) - 1
            // 0xffffffffff - (2^40 - 1) - 40-bit-number
        }
    }
}

