// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/Gath3r.sol";

contract Gath3rTest is Test {
    Gath3r gath3r;

    function setUp() public {
        gath3r = new Gath3r();
    }

    function test_CreateGroup() public {
        gath3r.createGroup("Test Group");
        address[] memory groups = gath3r.getMyGroups();
        assertEq(groups.length, 1);
    }
}
