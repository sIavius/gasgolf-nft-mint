//NFTDropRead.t.sol
pragma solidity ^0.8.37;

import {NFTDrop} from "../src/NFTDropOZ.sol";
import {Test} from "forge-std/Test.sol";
contract NFTDropRead is Test {
    function testDefaultStorageRead() public {
        NFTDrop NFTDropSample = new NFTDrop();
        bool _paused;
        uint40 _allowlistStart;

        (_paused, _allowlistStart) = NFTDropSample.defaultStorageRead();
        assertEq(_paused, false);
        assertEq(_allowlistStart, 0);
    }

    function testSetter() public {
        NFTDropChild NFTDropChildSample = new NFTDropChild();
        NFTDropChildSample.childSetter(true, 5); //random number
        bool _childPaused;
        uint40 _childAllowlistStart;
        (_childPaused, _childAllowlistStart) = NFTDropChildSample.defaultStorageRead();

        assertEq(_childPaused, true);
        assertEq(_childAllowlistStart, 5);
    }
}

contract NFTDropChild is NFTDrop {
    function childSetter(bool paused, uint40 allowlistStart) public {
        config.paused = paused;
        config.allowlistStart = allowlistStart;
    }
}

