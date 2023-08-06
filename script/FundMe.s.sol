// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/FundMe.sol";

contract FundMeScript is Script{
    function run() external returns(FundMe) {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); // Sepolia Price Feed Address
        vm.stopBroadcast();
        // 效果等同于以下代码，只不过会消耗更多的 Gas:
        // vm.broadcast();
        // new FundMe(); // 只有在需要交互的情况下，才会将部署合约赋值给变量

        return fundMe;
    }
}