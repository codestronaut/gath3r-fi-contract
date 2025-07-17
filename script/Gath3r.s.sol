// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/Gath3r.sol";

contract Gath3rDeploy is Script {
    function run() external {
        vm.startBroadcast();
        new Gath3r();
        vm.stopBroadcast();
    }
}
