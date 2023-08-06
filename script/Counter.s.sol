// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Counter.sol";

contract CounterScript is Script {
    function run() public {
        // vm.broadcast();
        // new Counter();
        vm.startBroadcast();
        new Counter();
        vm.stopBroadcast();
    }
}