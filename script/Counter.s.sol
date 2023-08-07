// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Counter.sol";

contract CounterScript is Script {
    function run() public returns(Counter){
        vm.broadcast();
        Counter counter = new Counter();
        return counter;
    }
}