//NFTDropRead.t.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.38;

import {NFTDrop} from "../src/NFTDropOZ.sol";
import {Test} from "forge-std/Test.sol";
import {SaleConfigReader} from "../src/libraries/SaleConfigReader.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTDropRead is Test {
    NFTDropChild NFTDropChildSample = new NFTDropChild();

    function setUp() public {
        NFTDropChildSample.childSetter(true, 100, 200);
    }

    function testDefaultStorageRead() public {
        NFTDrop NFTDropSample = new NFTDrop("testName", "testSymbol");
        bool _paused;
        uint40 _allowlistStart;

        (_paused, _allowlistStart) = NFTDropSample.defaultStorageRead();
        assertEq(_paused, false);
        assertEq(_allowlistStart, 0);
    }

    function testSetter() public {
        NFTDropChildSample.childSetter(true, 256, 300); //256 - first 9-bit number
        bool _childPaused;
        uint40 _childAllowlistStart;
        (_childPaused, _childAllowlistStart) = NFTDropChildSample.defaultStorageRead();

        assertEq(_childPaused, true);
        assertEq(_childAllowlistStart, 256);
    }

    function testStorageReadsComparison() public {
        NFTDropChildSample.childSetter(true, 256, 300); //256 - first 9-bit number
        bool pausedVal;
        bool pausedValAssembly;
        uint40 allowListStart;
        uint40 allowListStartAssembly;

        (pausedVal, allowListStart) = NFTDropChildSample.defaultStorageRead();
        assertEq(pausedVal, true);
        assertEq(allowListStart, 256);

        (pausedValAssembly, allowListStartAssembly) = NFTDropChildSample.stateReader();
        assertEq(pausedValAssembly, true);
        assertEq(allowListStartAssembly, 256);

        assertEq(pausedVal, pausedValAssembly);
        assertEq(allowListStart, allowListStartAssembly);
    }

    function testMintPhases() public {
        NFTDropChildSample.childSetter(false, 100, 200);
        vm.warp(50);
        NFTDrop.MintPhases mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Closed);
        vm.warp(100);
        mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Allowlist);
        vm.warp(200);
        mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Public);
        vm.warp(99);
        mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Closed);
        vm.warp(199);
        mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Allowlist);
    }

    function testPhasesCollision() public {
        NFTDropChildSample.childSetter(false, 100, 100);
        vm.warp(99);
        NFTDrop.MintPhases mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Closed);
        vm.warp(100);
        mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Public);
        vm.warp(101);
        mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Public);
    }

    function testWhilePaused() public {
        NFTDropChildSample.childSetter(true, 100, 200);
        vm.warp(150);
        NFTDrop.MintPhases mintPhases = NFTDropChildSample.currentPhase();
        assertTrue(mintPhases == NFTDrop.MintPhases.Allowlist);
    }

    function testProperEncoding(uint16 _number) public pure {
        bytes memory encodeStandart = abi.encode(_number);
        bytes memory encodePacked = abi.encodePacked(_number);
        assertEq(encodeStandart.length, 32);
        assertEq(encodePacked.length, 2);
    }

    function testMint() public {
        vm.expectEmit(address(NFTDropChildSample));
        emit IERC721.Transfer(address(0), address(1), 7);
        NFTDropChildSample.mintSample(address(1), 7);
        assertEq(NFTDropChildSample.ownerOf(7), address(1));
        assertEq(NFTDropChildSample.balanceOf(address(1)), 1);
    }
}

contract NFTDropChild is NFTDrop("testName", "testSymbol") {
    function childSetter(bool paused, uint40 allowlistStart, uint40 publicStart) public {
        config.paused = paused;
        config.allowlistStart = allowlistStart;
        config.publicStart = publicStart;
    }

    function stateReader() public view returns (bool pausedVal, uint40 allowListStart) {
        uint256 _slotNumber;
        assembly {
            _slotNumber := config.slot
        }
        return SaleConfigReader.storageRead(_slotNumber);
    }

    function mintSample(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }
}

