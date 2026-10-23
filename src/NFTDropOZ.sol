//NFTDropOZ.sol
pragma solidity 0.8.38;

// SPDX-License-Identifier: MIT

contract NFTDrop {
    enum MintPhases {Closed, Allowlist, Public}
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

    function defaultStorageRead() public view returns (bool pausedVal, uint40 allowlistStartVal) {
        return (config.paused, config.allowlistStart);
    }

    function currentPhase() public view returns(MintPhases) {
        if(block.timestamp < config.allowlistStart) {
            return MintPhases.Closed;
            }

            else if(config.allowlistStart <= block.timestamp && block.timestamp < config.publicStart) {
                return MintPhases.Allowlist;
            }

            else return MintPhases.Public;
    }
}


    